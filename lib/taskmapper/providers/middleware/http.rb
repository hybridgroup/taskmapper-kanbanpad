module TaskMapper
  module Providers
    module Middleware
      module HTTP
        def get(url)
          body = connection.get("#{base_path}#{url}").body
          return body.map { |e| yield e } if block_given?
          body
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
