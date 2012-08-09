module TaskMapper
  module Providers
    module Kanbanpad
      module Projects
        include Middleware::HTTP
        
        def domain
          'https://www.kanbanpad.com'
        end
        
        def base_path
          '/api/v1'
        end
        
        def search(criteria)
          get('/projects.json').map do |kpp|
            {
              :name       => kpp.name,
              :created_at => Time.new(kpp.created_at),
              :updated_at => Time.new(kpp.updated_at)
            }
          end
        end
      end
    end
  end
end
