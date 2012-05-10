require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Kanbanpad::Project do
  before(:all) do
    headers = {'Authorization' => 'Basic YWJjQGcuY29tOmllODIzZDYzanM='}
    wheaders = headers.merge('Accept' => 'application/json')
    @project_id = 'be74b643b64e3dc79aa0'
   ActiveResource::HttpMock.respond_to do |mock|
     mock.get '/api/v1/projects.json', wheaders, fixture_for('projects'), 200
     mock.get '/api/v1/projects/be74b643b64e3dc79aa0.json', wheaders, fixture_for('projects/be74b643b64e3dc79aa0'), 200
     mock.get '/api/v1/projects/create.json', headers, fixture_for('projects/create'), 200
   end
  end
      
  before(:each) do
	  @taskmapper = TaskMapper.new(:kanbanpad, :username => 'abc@g.com', :password => 'ie823d63js')
    @klass = TaskMapper::Provider::Kanbanpad::Project
  end
  
  it "should be able to load all projects" do
    @taskmapper.projects.should be_an_instance_of(Array)
    @taskmapper.projects.first.should be_an_instance_of(@klass)
  end
  
  it "should be able to load projects from an array of ids" do
    @projects = @taskmapper.projects([@project_id])
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.slug.should == @project_id
  end
  
  it "should be able to load all projects from attributes" do
    @projects = @taskmapper.projects(:slug => @project_id)
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.slug.should == @project_id
  end
  
  it "should be able to find a project" do
    @taskmapper.project.should == @klass
    @taskmapper.project.find(@project_id).should be_an_instance_of(@klass)
  end
  
  it "should be able to find a project by slug" do
    @taskmapper.project(@project_id).should be_an_instance_of(@klass)
    @taskmapper.project(@project_id).slug.should == @project_id
  end

end
