module TaskMapper::Provider
  module Kanbanpad
    class Project < TaskMapper::Provider::Base::Project
      API = KanbanpadAPI::Project
      COMMENT_API = KanbanpadAPI::ProjectComment

      # Public: Creates a new Project based on the provided hash
      #
      # project - Hash of Project values to use when creating a new Project
      #
      # Returns a new Project
      def initialize(*project)
        project = project.first if project.first
        @system_data = {:client => project}
        super project
      end

      # Public: Copies one project's tickets/comments onto another
      #
      # project - project whose attributes should be copied onto the caller
      #
      # Returns the updated Project
      #
      # Examples:
      #   project = taskmapper.project 1
      #   other_project = taskmapper.project 2
      #   project.copy(other_project)
      #   #=> Returns project, now with other_project's tickets and comments
      def copy(project)
        project.tickets.each do |ticket|
          copy_ticket = self.ticket!(
            :title => ticket.title,
            :description => ticket.description
          )

          ticket.comments.each do |comment|
            copy_ticket.comment! :body => comment.body
            sleep 1
          end
        end
        self
      end

      def id
        self[:slug]
      end

      def created_at
        Time.parse(self[:created_at])
      rescue
        self[:created_at]
      end

      def updated_at
        Time.parse(self[:updated_at])
      rescue
        self[:updated_at]
      end

      # Public: Creates a new Comment for the Project
      #
      # attributes - Hash of attributes to be used when creating the comment
      #
      # Returns a new comment if the comment was persisted, otherwise false
      def comment!(attributes)
        comment = create_comment attributes
        if comment.save
          Comment.new comment.attributes.merge :project_id => id
        else
          false
        end
      end

      # Public: Fetches all Comments belonging to the project
      #
      # Returns an array of Comments
      def comments
        find_comments.map { |c| Comment.new c.attributes }
      end

      private
      # Private: Finds all Comments belonging to the Project from the Kanbanpad
      # API
      #
      # Returns an array of Comments
      def find_comments
        params = { :project_id => id }
        COMMENT_API.find :all, :params => params
      end

      # Private: Creates a new project comment using the Kanbanpad API
      #
      # attrs - attributes to use when creating comment
      #
      # Returns a KanbanpadAPI::ProjectComment instance
      def create_comment(attrs)
        attrs.merge! :project_id => id
        COMMENT_API.new attrs
      end
    end
  end
end
