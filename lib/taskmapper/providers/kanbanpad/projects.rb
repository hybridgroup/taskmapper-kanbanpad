module TaskMapper
  module Providers
    module Kanbanpad
      module Projects
        include Middleware::HTTP
        
        def search(criteria)
          get('/projects.json') do |kpp|
            {
              :id         => kpp.slug,
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
