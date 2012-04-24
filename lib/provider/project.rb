module TaskMapper::Provider
  module Kanbanpad
    # Project class for taskmapper-kanbanpad
    # 
    # 
    class Project < TaskMapper::Provider::Base::Project
      # declare needed overloaded methods here
      API = KanbanpadAPI::Project
      COMMENT_API = KanbanpadAPI::ProjectComment
      
      def initialize(*object)
        if object.first
          object = object.first
          @system_data = {:client => object}
          unless object.is_a? Hash
            hash = {:id => object.slug,
                    :name => object.name, 
                    :slug => object.slug,
                    :created_at => object.created_at,
                    :updated_at => object.updated_at}
          else
            hash = object
          end
          super hash
        end
      end

      # copy from this.copy(that) copies that into this
      def copy(project)
        project.tickets.each do |ticket|
          copy_ticket = self.ticket!(:title => ticket.title, :description => ticket.description)
          ticket.comments.each do |comment|
            copy_ticket.comment!(:body => comment.body)
            sleep 1
          end
        end
      end

      def id
        self[:slug]
      end

      def ticket!(attributes)
        Ticket.create(attributes.merge!(:project_id => id))
      end

      def created_at
        begin
          Time.parse(self[:created_at])
        rescue
          self[:created_at]
        end
      end

      def updated_at
        begin
          Time.parse(self[:updated_at])
        rescue
          self[:updated_at]
        end
      end
      
      def comment!(attributes)
        comment = create_comment attributes
        Comment.new(comment.attributes.merge :project_id => id) if comment.save
      end
      
      def comments
        find_comments.map { |c| Comment.new c.attributes }
      end
      
      private
        def find_comments
          COMMENT_API.find(:all, :params => { :project_id => id })
        end
        
        def create_comment(attributes)
          COMMENT_API.new(attributes.merge(:project_id => id))
        end
    end
  end
end
