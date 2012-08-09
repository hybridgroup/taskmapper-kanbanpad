require "faraday"
require "faraday_middleware"
require "hashie/mash"

require_relative "middleware/http"
require_relative "kanbanpad/version"
require_relative "kanbanpad/projects"
require_relative "kanbanpad/tasks"
require_relative "kanbanpad/task_comments"

module TaskMapper
  module Providers
    module Kanbanpad
    end
  end
end
