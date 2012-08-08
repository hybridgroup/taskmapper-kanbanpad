require 'spec_helper'

describe "Search Projects" do
  it "should search projects" do
    tm = TaskMapper.new :kanbanpad, :username => 'omar', :password => 1234
    tm.projects.each { |p| puts p.inspect }
  end
end
