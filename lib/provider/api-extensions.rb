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

end

class KanbanpadAPI::Task
  include APIExtentions

  #FIXME: This is an ugly hack, duplication...
  def update_with(ticket)
    self.assigne_to = ticket.assignee
    self.title = ticket.title
    self.project_id = ticket.project_slug
    self.step_id = ticket.step_id
    self.note = ticket.description
    self
  end
end

class KanbanpadAPI::TaskList
  include APIExtentions

  def update_with(ticket)
    self.assigne_to = ticket.assignee
    self.title = ticket.title
    self.project_id = ticket.project_slug
    self.step_id = ticket.step_id
    self.note = ticket.description
    self
  end
end
