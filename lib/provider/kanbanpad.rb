module TaskMapper::Provider
  module Kanbanpad
    include TaskMapper::Provider::Base
    TICKET_API = KanbanpadAPI::Task
    PROJECT_API = KanbanpadAPI::Project

    class << self

      # Public: Method to create a new TaskMapper Kanbanpad provider
      #
      # auth - hash of authentication options
      #
      # Returns a new TaskMapper instance
      # Examples:
      #
      #   TaskMapper::Provider::Kanbanpad.new({:username => u, :password => p})
      #   #=> <Taskmapper>
      def new(auth = {})
        TaskMapper.new(:kanbanpad, auth)
      end
    end

    # Public: Checks authentication and auths against Kanbanpad API
    #
    # auth - hash of authentication options
    #
    # Returns nothing
    def authorize(auth = {})
      auth = @authentication ||= TaskMapper::Authenticator.new(auth)

      if auth[:username].blank? && auth[:email].blank?
        message = "Please provide a username or email."
        raise TaskMapper::Exception.new message
      end

      if auth[:token].blank? && auth[:password].blank?
        message = "Please provide a token or password."
        raise TaskMapper::Exception.new message
      end

      username = (auth[:username].blank? ? auth[:email] : auth[:username])
      password = (auth[:token].blank? ? auth[:password] : auth[:token])

      KanbanpadAPI.authenticate username, password
    end

    # Public: Used to check if API connection is set up properly and valid.
    #
    # Returns true if API is set up correctly, false otherwise
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
