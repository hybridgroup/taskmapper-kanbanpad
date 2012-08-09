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
      def self.domain
        'https://www.kanbanpad.com'
      end
        
      def self.base_path
        '/api/v1'
      end
    end
  end
end
