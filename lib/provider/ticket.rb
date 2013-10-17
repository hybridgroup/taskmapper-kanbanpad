module TaskMapper::Provider
  module Kanbanpad
    # Ticket class for taskmapper-kanbanpad
    #
    class Ticket < TaskMapper::Provider::Base::Ticket
      API = KanbanpadAPI::TaskList
      STEP_API = KanbanpadAPI::Step
      TASK_COMMENT_API = KanbanpadAPI::TaskCommentCreator

      # Public: Returns the Ticket's Priority based on the 'urgent' attribute
      #
      # Returns a String
      def priority
        self.urgent ? "Urgent" : "Not Urgent"
      end

      # Public: Returns the Ticket's current status
      #
      # Returns a String
      def status
        return "Finished" if self.finished
        return "Backlog" if self.backlog
        self.wip? ? "#{step_name} - In-Progress" : "#{step_name} - Queue"
      end

      # Public: Returns the Ticket's description
      #
      # Returns a String
      def description
        self.note
      end

      # Public: Returns the Ticket's Assignee
      #
      # Returns a string
      def assignee
        self[:assignee].first.blank? ? 'Nobody' : self[:assignee].first
      end

      # Public: Returns the ID/slug of the project the Ticket belongs to
      #
      # Returns a String
      def project_id
        self.project_slug
      end

      # Public: Gives an created_at Time for the Ticket.
      #
      # Returns a Time object or a string if it couldn't be parsed
      def created_at
        if self[:created_at].blank?
          # Kanbanpad didn't always track created_at
          Time.parse('2010-03-25 3:06:34')
        else
          begin
            Time.parse(self[:created_at])
          rescue
            self[:created_at]
          end
        end
      end

      # Public: Persists the Ticket to Kanbanpad.
      #
      # Returns true if ticket saved, false otherwise
      def save
        new? ? to_issue.save : update
      end

      # Public: Checks if the ticket is new and has not been persisted to
      # Kanbanpad yet
      #
      # Returns a boolean
      def new?
        project_id.nil? && step_id.nil?
      end

      # Public: Gives an updated_at Time for the Ticket.
      #
      # Returns a Time object or a string if it couldn't be parsed
      def updated_at
        if self[:updated_at].blank?
          # Kanbanpad didn't always track updated_at
          Time.parse('2010-03-25 3:06:34')
        else
          begin
            Time.parse(self[:updated_at])
          rescue
            self[:updated_at]
          end
        end
      end

      # Public: Creates a new Comment on the Ticket and persists it to Kanbanpad
      #
      # attrs - hash of comment attributes
      #
      # Returns a new Comment instance
      def comment!(attrs)
        attrs.merge!(
          :project_id => self.project_id,
          :task_id => self.id,
          :step_id => self.step_id
        )

        task_comment = TASK_COMMENT_API.new attrs
        task_comment.save
        comment = Comment.new task_comment.attributes.merge(:ticket_id => id)
      end

      class << self
        # Public: Creates and persists a new Ticket to Kanbanpad
        #
        # attributes - hash of Ticket attributes
        #
        # Returns the new Ticket or false if it failed to persist to Kanbanpad
        def create(attributes)
          ticket = self.new(attributes)
          if ticket.save
            ticket
          else
            false
          end
        end

        # Public: Finds a specific Ticket by it's ID and project_id
        #
        # project_id - Project ID of the Ticket to search for
        # ticket_id - ID of the Ticket to find
        #
        # Returns a Ticket instance
        def find_by_id(project_id, ticket_id)
          ticket = API.find(ticket_id, :params => { :project_id => project_id })
          self.new ticket.to_ticket_hash
        end

        # Public: Searches through all tickets for a Project, finding those that
        # match a supplied hash of attributes
        #
        # project_id - the Project whose tickets should be searched
        # attributes - Hash of attributes to use when searching the tickets
        #
        # Public: Returns a Hash of matching Tickets
        def find_by_attributes(project_id, attributes = {})
          search_by_attribute(find_all(project_id), attributes)
        end

        # Public: Finds all tickets belonging to a Project
        #
        # project_id - ID of the Project whose tickets should be fetched
        #
        # Returns an array of Tickets
        def find_all(project_id)
          API.find(
            :all,
            :params => {
              :project_id => project_id,
              :backlog => 'yes',
              :finished => 'yes'
            }
          ).collect { |task| self.new task.to_ticket_hash }
        end
      end

      private
      def step_name
        STEP_API.find(
          self.step_id,
          :params => {:project_id => self.project_id}
        ).name
      end

      # Public: Finds a Task in Kanbanpad that corresponds to the TaskMapper
      # Ticket
      #
      # Returns the matching Task or raises an error if it can't be found
      def find_task
        task = KanbanpadAPI::Task.find(
          id,
          :params => { :project_id => project_id, :step_id => step_id }
        )
        if task
          return task
        else
          raise TaskMapper::Exception.new "Task with #{id} was not found"
        end
      end

      # Public: Updates the Ticket's Kanbanpad Task
      #
      # Returns boolean indicating whether or not the Ticket was updated
      def update
        find_task.update_with(self).save
      end

      def to_issue
        KanbanpadAPI::TaskList.new(self)
      end
    end
  end
end
