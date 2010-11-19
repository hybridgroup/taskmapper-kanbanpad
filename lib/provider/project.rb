module TicketMaster::Provider
  module Kanbanpad
    # Project class for ticketmaster-kanbanpad
    # 
    # 
    class Project < TicketMaster::Provider::Base::Project
      # declare needed overloaded methods here
      API = KanbanpadAPI::Project
	  
      alias_method :tasks, :tickets
      alias_method :task, :ticket

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

    end
  end
end
