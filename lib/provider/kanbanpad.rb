module TaskMapper::Provider
  # This is the Kanbanpad Provider for taskmapper

  module Kanbanpad
    include TaskMapper::Provider::Base
    TICKET_API = KanbanpadAPI::Task
    PROJECT_API = KanbanpadAPI::Project

    # This is for cases when you want to instantiate using TaskMapper::Provider::Kanbanpad.new(auth)
    def self.new(auth = {})
      TaskMapper.new(:kanbanpad, auth)
    end

    # The authorize and initializer for this provider
    def authorize(auth = {})
      @authentication ||= TaskMapper::Authenticator.new(auth)
      auth = @authentication
      if (auth.username.blank? and auth.email.blank?) and (auth.token.blank? and auth.password.blank?)
        raise "Please provide at least a set of username and password)"
      end
      KanbanpadAPI.authenticate((auth.username.blank? ? auth.email : auth.username), (auth.password.blank? ? auth.token : auth.password))
    end

    def valid?
      begin
        PROJECT_API.find(:first).nil?
        true
      rescue
        false
      end
    end
  end
end
