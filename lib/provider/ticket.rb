module TicketMaster::Provider
  module Kanbanpad
    # Ticket class for ticketmaster-kanbanpad
    #
    class Ticket < TicketMaster::Provider::Base::Ticket
      API = KanbanpadAPI::TaskList
      STEP_API = KanbanpadAPI::Step
      TASK_COMMENT_API = KanbanpadAPI::TaskCommentCreator

      def initialize(*args)
        case args.first
        when Hash then super args.first
        when KanbanpadAPI::Task then super args.first.to_ticket_hash
        when KanbanpadAPI::TaskList then super args.first.to_ticket_hash
        else raise ArgumentError.new
        end
      end

      def priority
        self.urgent ? "Urgent" : "Not Urgent"
      end

      def status
        return "Finished" if self.finished
        return "Backlog" if self.backlog
        self.wip? ? "#{step_name} - In-Progress" : "#{step_name} - Queue"
      end

      def description
        self.note
      end

      def assignee
        self.assigned_to.blank? ? 'Nobody' : self.assigned_to.first
      end

      def project_id
        self.project_slug
      end

      def created_at
        if self[:created_at].blank?
          Time.parse('2010-03-25 3:06:34') #kanbanpad used to not track the created_at
        else
          begin
            Time.parse(self[:created_at])
          rescue
            self[:created_at]
          end
        end
      end

      def save
        task = to_issue
        task.new? ? task.save : update
      end

      def new?
        id.nil? 
      end

      def self.create(attributes)
        ticket = self.new(attributes)
        ticket if ticket.save
      end

      def self.find_by_attributes(project_id, attributes = {})
        search_by_attribute(search(project_id), attributes)
      end

      def self.search(project_id, options = {}, limit = 1000)
        API.find(:all, :params => {:project_id => project_id, :backlog => 'yes', :finished => 'yes'}).collect do |task|
          self.new task
        end
      end

      def updated_at
        if self[:updated_at].blank?
          Time.parse('2010-03-25 3:06:34') #kanbanpad used to not track the updated_at
        else
          begin
            Time.parse(self[:updated_at])
          rescue
            self[:updated_at]
          end
        end
      end

      #TODO?
      def comment
        warn 'Kanbanpad does not allow find by id of comments. Perhaps you should leave feedback to request it?'
        nil
      end

      def comment!(*options)
        if options.first.is_a? Hash
          options.first.merge!(:project_id => self.project_id,
                               :task_id => self.id,
                               :step_id => self.step_id)

          task_comment = TASK_COMMENT_API.new(options.first)
          task_comment.save
          comment = Comment.new(task_comment.attributes)
        end
      end

      private
      def step_name
        STEP_API.find(self.step_id, :params => {:project_id => self.project_id}).name
      end

      def find_task
        task = KanbanpadAPI::Task.find(id, :params => {:project_id => project_id, :step_id => step_id})
        raise TicketMaster::Exception.new "Task with #{id} was not found" unless task
        task
      end

      def update
        find_task.update_with(self).save
      end

      def to_issue
        API.new.update_with(self)
      end
    end

    class Net::HTTP
      def send(*args)
        p "<<< Net::HTTP#send #{args.inspect}"
        resp = super
        p "<<< Response #{resp.inspect}"
        resp
      end
    end
  end
end
