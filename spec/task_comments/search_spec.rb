require 'spec_helper'

describe "Search Tasks" do
  it "should search all task comments" do
    tm = TaskMapper.new :kanbanpad, 
      :username => 'clutch@hybridgroup.com', 
      :password => '6b2c16d562cce8eca2878966d64365a50acdc5fd'
      
    project = tm.projects.first
    tasks = project.tasks.to_a
    task = tasks.first
    
    comments = task.comments
    
    comments.count.should == 6
    
    comment = comments.first
    
    comment.body.should == "testing comments"
    comment.author.should == "<clutch@hybridgroup.com>"
    
    comment.task_id.should == task.id
    comment.task.should == task
    comment.created_at.should be_a Time
    comment.updated_at.should be_a Time
  end
end
