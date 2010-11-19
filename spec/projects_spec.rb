require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Kanbanpad::Project" do
  before(:all) do
    headers = {}
    @project_id = 'be74b643b64e3dc79aa0'
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/api/v1/projects.xml', headers, fixture_for('projects'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0.xml', headers, fixture_for('projects/be74b643b64e3dc79aa0'), 200
      #mock.get '/api/v1/projects/create.xml', headers, fixture_for('projects/create'), 200
    end
  end
      
  before(:each) do
    @ticketmaster = TicketMaster.new(:kanbanpad, {})
    @klass = TicketMaster::Provider::Kanbanpad::Project
  end
  
  it "should be able to load all projects" do
    @ticketmaster.projects.should be_an_instance_of(Array)
    @ticketmaster.projects.first.should be_an_instance_of(@klass)
  end
  
  it "should be able to load projects from an array of ids" do
    @projects = @ticketmaster.projects([@project_id])
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.slug.should == @project_id
  end
  
  it "should be able to load all projects from attributes" do
    @projects = @ticketmaster.projects(:slug => @project_id)
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.slug.should == @project_id
  end
  
  it "should be able to find a project" do
    @ticketmaster.project.should == @klass
    @ticketmaster.project.find(@project_id).should be_an_instance_of(@klass)
  end
  
  it "should be able to find a project by slug" do
    @ticketmaster.project(@project_id).should be_an_instance_of(@klass)
    @ticketmaster.project(@project_id).slug.should == @project_id
  end

end
