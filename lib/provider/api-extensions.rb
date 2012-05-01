module APIExtentions
  def to_ticket_hash
    {:id => id, 
    :title => title, 
    :created_at => created_at, 
    :updated_at => updated_at, 
    :wip => wip, 
    :step_id => step_id, 
    :project_slug => project_slug,
    :finished => finished, 
    :backlog => backlog, 
    :assignee => assigned_to}
  end

  def update_with(ticket)
    self.assigned_to = ticket.assignee == 'Nobody' ? '' : ticket.assignee
    self.title = ticket.title
    self.task_id = ticket.id
    self.note = ticket.description
    self
  end

end

class KanbanpadAPI::Task
  include APIExtentions
end

class KanbanpadAPI::TaskList
  include APIExtentions
end
