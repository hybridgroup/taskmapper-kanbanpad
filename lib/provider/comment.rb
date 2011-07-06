module TicketMaster::Provider
  module Kanbanpad
    # The comment class for ticketmaster-kanbanpad
    #
    # Do any mapping between Ticketmaster and your system's comment model here
    # versions of the ticket.
    #
    # Not supported by Kanbanpad API
    class Comment < TicketMaster::Provider::Base::Comment
      # declare needed overloaded methods here
      API = KanbanpadAPI::TaskComment
      
      def self.find_by_id(project_id, ticket_id, id)
        self.search(project_id, ticket_id).select { |ticket| ticket.id == id }.first
      end

      def self.find_by_attributes(project_id, ticket_id, attributes = {})
        search_by_attribute(self.search(project_id, ticket_id), attributes)
      end

      def self.search(project_id, ticket_id, options = {}, limit = 1000)
        comments = API.find(:all, :params => {:project_id => project_id, :task_id => ticket_id}).collect { |comment| self.new comment }
      end

      def self.create(*options)
        comment = API.new options[0].first
        self.new comment
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
      
    end
  end
end
