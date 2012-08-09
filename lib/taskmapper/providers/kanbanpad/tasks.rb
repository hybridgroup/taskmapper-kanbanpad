module TaskMapper
  module Providers
    module Kanbanpad
      module Tasks
        include Middleware::HTTP
        
        def search(criteria)
          get("/projects/#{criteria[:project_id]}/tasks.json") do |task|
            {
              :id         => task.task_id,
              :title      => task.title,
              :requestor  => "Not available",
              :assignee   => task.assigned_to,
              :priority   => (task.urgent ? 1 : 2),
              :status     => get_status(task.backlog, task.finished),
              :created_at => Time.new(task.created_at),
              :updated_at => Time.new(task.updated_at)
            }
          end
        end
        
        private
          def get_status(in_backlog, finished)
            return :new     if in_backlog
            return :closed  if finished
            :in_progress
          end
      end
    end
  end
end
