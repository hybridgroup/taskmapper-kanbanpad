module TicketMaster::Provider
  # This is the Kanbanpad Provider for ticketmaster
  module Kanbanpad
    include TicketMaster::Provider::Base
    
    # This is for cases when you want to instantiate using TicketMaster::Provider::Kanbanpad.new(auth)
    def self.new(auth = {})
      TicketMaster.new(:kanbanpad, auth)
    end
    
    # declare needed overloaded methods here
    
  end
end
