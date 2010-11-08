require 'rubygems'
require 'ticketmaster'
require 'active_support'
require 'active_resource'

# Ruby lib for working with the Kanbanpad API's XML interface.  
# You should set the authentication using your login
# credentials with HTTP Basic Authentication. 
#
#   using email and user api key
#   KanbanpadAPI.authenticate('rick@techno-weenie.net', '70b4b722d55387286b817642289392a64d20b25e')
#
#
# This library is a small wrapper around the REST interface.  

module KanbanpadAPI
  class Error < StandardError; end
  class << self

    # Sets up basic authentication credentials for all the resources.
    def authenticate(email, password)
      @email    = email
      @password = password
      self::Base.user = email
      self::Base.password = password
    end

    def resources
      @resources ||= []
    end
  end
  
  class Base < ActiveResource::Base
    self.site = "http://localhost:9292/api/v1/"
    def self.inherited(base)
      KanbanpadAPI.resources << base
      class << base
        attr_accessor :site_format
      end
      base.site_format = '%s'
      super
    end
  end
  
  # Find projects
  #
  #   KanbanpadAPI::Project.find(:all) # find all projects for the current account.
  #   KanbanpadAPI::Project.find('7e2cad4b3cbe5954950c')   # find individual project by slug
  #
  #
  # Finding tickets
  # 
  #   project = KanbanpadAPI::Project.find('7e2cad4b3cbe5954950c')
  #   project.tickets
  #
  # Finding finished tickets from project
  #   
  #   KanbanpadAPI::Task.finished('7e2cad4b3cbe5954950c')
  #
  
  class Project < Base
    def tickets(options = {})
      Task.find(:all, :params => options.update(:slug => slug))
	end
	
	def steps(options = {})
	  Step.find(:all, :params => options.update(:slug => slug))
	end
  end
  
  class Task < Base
    self.site += 'projects/:slug'
	
	def self.finished(project_id, options = {})
      find(:all, :params => options.merge(:slug => project_id), :from => :finished)
	end
	
	def self.backlog(project_id, options = {})
      find(:all, :params => options.merge(:slug => project_id), :from => :backlog)
	end
  end
  
  class Step < Base
    self.site += 'projects/:slug'
	
	def tickets(options = {})
	  Task.find(:all, :params => options.merge(prefix_options).update(:q => %{slug:"#{project_id}"}))
	end
  end
  
 end
