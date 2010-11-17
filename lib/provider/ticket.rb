module TicketMaster::Provider
  module Kanbanpad
    # Ticket class for ticketmaster-kanbanpad
    #
    
    class Ticket < TicketMaster::Provider::Base::Ticket
      # declare needed overloaded methods here
      API = KanbanpadAPI::Task
      
    end
  end
end
