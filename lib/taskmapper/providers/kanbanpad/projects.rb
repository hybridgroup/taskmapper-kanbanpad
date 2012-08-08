module TaskMapper
  module Providers
    module Kanbanpad
      module Projects
        
        def search(criteria)
          get '/projects'
        end
        
      end
    end
  end
end
