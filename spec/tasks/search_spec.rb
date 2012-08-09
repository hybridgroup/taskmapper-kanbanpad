require 'spec_helper'

describe "Search Tasks" do
  it "should search all tasks" do
    tm = TaskMapper.new :kanbanpad, 
      :username => 'clutch@hybridgroup.com', 
      :password => '6b2c16d562cce8eca2878966d64365a50acdc5fd'
      
    project = tm.projects.first
    tasks = project.tasks.to_a
    
    tasks.count.should == 3
    
    task = tasks[1]
    task.id.should == 2
    task.title.should == "testing a new ticket"
    task.requestor.should == "Not available"
    task.assignee.should == []
    task.priority.should == 2
    task.status.should == :in_progress
    task.created_at.should be_a Time
    task.updated_at.should be_a Time
  end
end
