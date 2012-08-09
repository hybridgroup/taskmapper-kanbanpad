module TaskMapper
  module Providers
    module Middleware
      module HTTP
        def get(url)
          resp = connection.get("#{base_path}#{url}")
          body = resp.body
          return body.map { |e| yield e } if block_given? and resp.success?
          body
        end
        
        def connection
          con = Faraday.new(:url => domain) do |c|
            c.adapter Faraday.default_adapter
            c.basic_auth(credentials[:username], credentials[:password])
            c.response :mashify,  :content_type => /\bjson$/
            c.response :json,     :content_type => /\bjson$/
            c.response :logger if debug
          end
        end
        
        def debug
          false
        end
      end
    end
  end
end
