module TicketMaster::Provider
  module Kanbanpad
    # Ticket class for ticketmaster-kanbanpad
    #
    class Ticket < TicketMaster::Provider::Base::Ticket
      API = KanbanpadAPI::Task
      STEP_API = KanbanpadAPI::Step

      def status
        return "Finished" if self.finished
        return "Backlog" if self.backlog
        self.wip? ? "#{step_name} - In-Progress" : "#{step_name} - Queue"
      end

      def description
        self.note
      end

      def assignee
        self.assigned_to.first
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

      def self.create(*options)
        if options.first.is_a? Hash
          options.first.merge!(:assigned_to => options.first.delete('assignee'),
                               :note => options.first[:description])
          task = API.new(options.first)
          ticket = self.new task
          task.save
          ticket
        end
      end

      def self.find_by_attributes(project_id, attributes = {})
        self.search_by_attribute(self.search(project_id), attributes)
      end

      def self.search(project_id, options = {}, limit = 1000)
        tickets = API.find(:all, :params => {:project_id => project_id, :backlog => 'yes', :finished => 'yes'}).collect do |ticket|
          self.new ticket
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

      #TODO? Exists...need to hook this up and test
      def comment!
        warn 'Perhaps you should leave feedback to request it?'
        []
      end

      private
      def step_name
        STEP_API.find(self.step_id, :params => {:project_id => self.project_id}).name
      end

    end
  end
end
