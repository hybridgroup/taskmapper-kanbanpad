module TaskMapper
  module Providers
    module Kanbanpad
      module Projects
        def search(criteria)
          con = Faraday.new(:url => 'https://www.kanbanpad.com') do |c|
            c.adapter Faraday.default_adapter
            c.basic_auth(credentials[:username], credentials[:password])
          end
          
          resp = con.get('/api/v1/projects.json')
          
          if resp.success?
            json_resp = JSON.parse resp.body
            
            json_resp.map do |kpp|
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
end