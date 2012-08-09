module TaskMapper
  module Providers
    module Middleware
      module HTTP
        def get(url)
          connection.get("#{base_path}#{url}").body
        end
        
        def connection
          con = Faraday.new(:url => domain) do |c|
            c.adapter Faraday.default_adapter
            c.basic_auth(credentials[:username], credentials[:password])
            c.response :json, :content_type => /\bjson$/
          end
        end
      end
    end
  end
end

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
              :name       => kpp["name"],
              :created_at => Time.new(kpp["created_at"]),
              :updated_at => Time.new(kpp["updated_at"])
            }
          end
        end
      end
    end
  end
end
