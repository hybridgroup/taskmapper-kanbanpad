module TaskMapper
  module Providers
    module Kanbanpad
      module TaskComments
        include Middleware::HTTP
        
        def search(criteria)
          task = criteria[:task]
          get("/projects/#{task.project_id}/tasks/#{task.id}/comments.json") do |comment|
            {
              :id         => comment.id,
              :body       => comment.body,
              :author     => comment.author,
              :created_at => Time.new(comment.created_at),
              :updated_at => Time.new(comment.updated_at)
            }
          end
        end
      end
    end
  end
end
