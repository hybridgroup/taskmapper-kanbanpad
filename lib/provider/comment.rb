module TaskMapper::Provider
  module Kanbanpad
    class Comment < TaskMapper::Provider::Base::Comment
      API = KanbanpadAPI::TaskComment

      # Public: Gives an updated_at Time for the Comment.
      #
      # Returns a Time object or a string if it couldn't be parsed
      def updated_at
        @updated_at ||= begin
          Time.parse(self[:updated_at])
        rescue
          self[:updated_at]
        end
      end

      # Public: Gives an created_at Time for the Comment.
      #
      # Returns a Time object or a string if it couldn't be parsed
      def created_at
        @created_at ||= begin
          Time.parse(self[:created_at])
        rescue
          self[:created_at]
        end
      end

      class << self
        # Public: Finds a specific Comment by it's project/ticket/comment IDs
        #
        # project_id - the ID of the project the comment belongs to
        # ticket_id - the ID of the ticket the comment belongs to
        # comment_id - the ID of the comment to find
        #
        # Returns the requested Comment instance
        def find_by_id(project_id, ticket_id, id)
          find_by_attributes(project_id, ticket_id, :id => id).first
        end

        # Public: Finds all Comments that match an array of attributes
        #
        # project_id - the ID of the project the ticket belongs to
        # ticket_id - the ID of the ticket to find comments for
        # attributes - a hash of attributes to search with
        #
        # Returns an Array of matching comments
        def find_by_attributes(project_id, ticket_id, attributes = {})
          search_by_attribute(self.find_all(project_id, ticket_id), attributes)
        end

        # Public: Finds all Comments that belong to a project/ticket
        #
        # project_id - the ID of the project the ticket belongs to
        # ticket_id - the ID of the ticket to find comments for
        #
        # Returns an Array of all comments
        def find_all(project_id, ticket_id)
          comments = API.find(
            :all,
            :params => { :project_id => project_id, :task_id => ticket_id }
          )

          comments.collect { |comment| self.new comment.attributes }
        end

        # Public: Creates a new Comment based on passed attributes
        #
        # project_id - the ID of the project the ticket belongs to
        # ticket_id - the ID of the ticket to create a comment for
        # step_id - the step to create a comment for
        # attrs - hash of Comment attributes
        #
        # Returns a new Comment instance
        def create(project_id, ticket_id, step_id, attrs)
          attrs.merge!(
            :project_id => project_id,
            :task_id => ticket_id,
            :step_id => step_id
          )

          task_comment = KanbanpadAPI::TaskCommentCreator.new attrs
          task_comment.save
          self.new task_comment
        end
      end
    end
  end
end
