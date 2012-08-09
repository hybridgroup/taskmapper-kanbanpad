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
            c.response :mashify,  :content_type => /\bjson$/
            c.response :json,     :content_type => /\bjson$/
          end
        end
      end
    end
  end
end
