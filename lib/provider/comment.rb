module TaskMapper::Provider
  module Kanbanpad
    # The comment class for taskmapper-kanbanpad
    #
    # Do any mapping between taskmapper and your system's comment model here
    # versions of the ticket.
    #
    # Not supported by Kanbanpad API
    class Comment < TaskMapper::Provider::Base::Comment
      # declare needed overloaded methods here
      API = KanbanpadAPI::TaskComment
      
      def initialize(*object)
        if object.first
          object = object.first
          unless object.is_a? Hash
            hash = {:id => object.id,
                    :author => object.author,
                    :body => object.body,
                    :created_at => object.created_at,
                    :updated_at => object.updated_at}
          else
            hash = object
          end
          super hash
        end
      end

      def self.find_by_id(project_id, ticket_id, id)
        self.search(project_id, ticket_id).select { |ticket| ticket.id == id }.first
      end

      def self.find_by_attributes(project_id, ticket_id, attributes = {})
        search_by_attribute(self.search(project_id, ticket_id), attributes)
      end

      def self.search(project_id, ticket_id, options = {}, limit = 1000)
        comments = API.find(:all, :params => {:project_id => project_id, :task_id => ticket_id}).collect { |comment| self.new comment }
      end

      def updated_at
        @updated_at ||= begin
          Time.parse(self[:updated_at])
        rescue
          self[:updated_at]
        end
      end
      
      def created_at
        @updated_at ||= begin
          Time.parse(self[:created_at])
        rescue
          self[:created_at]
        end
      end

      def self.create(project_id, ticket_id, step_id, *options)
        options.first.merge!(
                       :project_id => project_id, 
                       :task_id => ticket_id, 
                       :step_id => step_id)
        task_comment = KanbanpadAPI::TaskCommentCreator.new(options.first)
        task_comment.save
        self.new task_comment
      end

    end
  end
end
