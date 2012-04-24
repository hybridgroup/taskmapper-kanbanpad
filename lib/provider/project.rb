module TicketMaster::Provider
  module Kanbanpad
    # Project class for ticketmaster-kanbanpad
    # 
    # 
    class Project < TicketMaster::Provider::Base::Project
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
      
      def comment!(*options)
        if options.first.is_a? Hash
          options.first.merge!(:project_id => self.id)
                               
          project_comment = COMMENT_API.new(options.first)
          project_comment.save
          comment = Comment.new(project_comment.attributes.merge :project_id => id)
        end
      end
      
      def comments
        find_comments.map { |c| Comment.new c.attributes }
      end
      
      private
        def find_comments
          COMMENT_API.find(:all, :params => { :project_id => id })
        end
    end
  end
end
