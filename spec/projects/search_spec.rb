require 'spec_helper'

describe "Search Projects" do
  it "should search projects" do
    tm = TaskMapper.new :kanbanpad, 
      :username => 'clutch@hybridgroup.com', 
      :password => '6b2c16d562cce8eca2878966d64365a50acdc5fd'
      
    projects = tm.projects.to_a
    projects.count.should == 1
    
    project = projects.first
    project.id.should == "4dc893a9ef6bcbc51a07"
    project.name.should == "Test Project"
    project.created_at.year.should == 2011
    project.updated_at.year.should == 2011
  end
end
