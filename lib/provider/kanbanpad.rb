module TicketMaster::Provider
  # This is the Kanbanpad Provider for ticketmaster
  
  module Kanbanpad
    include TicketMaster::Provider::Base
	TICKET_API = KanbanpadAPI::Task
    PROJECT_API = KanbanpadAPI::Project
    
    # This is for cases when you want to instantiate using TicketMaster::Provider::Kanbanpad.new(auth)
    def self.new(auth = {})
      TicketMaster.new(:kanbanpad, auth)
    end
  end
end
