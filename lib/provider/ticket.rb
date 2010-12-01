module TicketMaster::Provider
  module Kanbanpad
    # Ticket class for ticketmaster-kanbanpad
    #
    class Ticket < TicketMaster::Provider::Base::Ticket
      API = KanbanpadAPI::Task

      def status
        self.wip? ? 'in-progress' : 'queue'
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

      #TODO?
      def comments
        warn 'Kanbanpad does not have comments. Perhaps you should leave feedback to request it?'
        []
      end

      #TODO?
      def comment
        warn 'Kanbanpad does not have comments. Perhaps you should leave feedback to request it?'
        nil
      end

      #TODO?
      def comment!
        warn 'Kanbanpad does not have comments. Perhaps you should leave feedback to request it?'
        []
      end
      
    end
  end
end
