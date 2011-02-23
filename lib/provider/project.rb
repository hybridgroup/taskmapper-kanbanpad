module TicketMaster::Provider
  module Kanbanpad
    # Project class for ticketmaster-kanbanpad
    # 
    # 
    class Project < TicketMaster::Provider::Base::Project
      # declare needed overloaded methods here
      API = KanbanpadAPI::Project

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

      # TODO: Needs refactor
      def tickets(*options)
        if options.empty?
          collect_all_tickets          
        elsif options.first.is_a? Array
          collect_all_tickets.select do |ticket| 
            if options.first.any? {|id| id == ticket.id }
              ticket
            end
          end
        elsif options.first.is_a? Hash
          collect_all_tickets.select do |ticket|
            options.first.inject(true) do |memo, kv|
              break unless memo
              key, value = kv
              begin
                memo &= ticket.send(key) == value
              rescue NoMethodError
                memo = false
              end
              memo
            end
          end
        end
      end

      private
      def collect_all_tickets
        API.tickets(id).collect { |ticket| Ticket.new ticket }
      end

    end
  end
end
