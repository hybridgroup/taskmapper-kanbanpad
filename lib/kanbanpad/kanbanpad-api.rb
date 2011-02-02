require 'rubygems'
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
    self.site = "http://www.kanbanpad.com/api/v1/"
    self.format = :json
    def self.inherited(base)
      KanbanpadAPI.resources << base
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
    def tasks(options = {})
      Task.find(:all, :params => options.update(:project_id => slug, :backlog => 'yes', :finished => 'yes'))
    end
	
    def steps(options = {})
      Step.find(:all, :params => options.update(:project_id => slug))
    end

    def comments(options = {})
      ProjectComment.find(:all, :params => options.update(:project_id => slug))
    end
  end

  class Task < Base
    self.site += 'projects/:project_id/'
	
    def self.finished(project_id, options = {})
      find(:all, :params => options.merge(:slug => project_id), :from => :finished)
    end

    def self.backlog(project_id, options = {})
      find(:all, :params => options.merge(:slug => project_id), :from => :backlog)
    end

    def comments(options = {})
      TaskComment.find(:all, :params => options.merge(prefix_options).update(:id => id))
    end
  end

  class Step < Base
    self.site += 'projects/:project_id/'
	
    def tickets(options = {})
      Task.find(:all, :params => options.merge(prefix_options))
    end
  end
 
  class ProjectComment < Base
    self.site += 'projects/:project_id/'
    self.element_name = 'comment'
  end 

  class TaskComment < Base
    self.site += 'projects/:project_id/tasks/:task_id'
    self.element_name = 'comment'
  end
 end
