require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TicketMaster::Provider::Kanbanpad::Ticket do
  before(:all) do
    headers = {'Authorization' => 'Basic YWJjQGcuY29tOmllODIzZDYzanM='}
    wheaders = headers.merge('Accept' => 'application/json')
    post_data = {:tasks => {:title => 'new ticket'}}
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0.json', wheaders, fixture_for('projects/be74b643b64e3dc79aa0'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0/tasks.json', wheaders, fixture_for('tasks'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0/tasks.json?backlog=yes&finished=yes', wheaders, fixture_for('tasks'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0/tasks/4cd428c496f0734eef000007.json', wheaders, fixture_for('tasks/4cd428c496f0734eef000007'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0/steps/4dc312f49bd0ff6c37000040.json', wheaders, fixture_for('steps/4dc312f49bd0ff6c37000040'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0/tasks/4dc31c4c9bd0ff6c3700004e.json', wheaders, fixture_for('tasks/4dc31c4c9bd0ff6c3700004e'), 200
    end
    @project_id = 'be74b643b64e3dc79aa0'
    @ticket_id = '4cd428c496f0734eef000007'
    @ticket_id_without_assignee = '4dc31c4c9bd0ff6c3700004e'
  end

  before(:each) do
    @ticketmaster = TicketMaster.new(:kanbanpad, :username => 'abc@g.com', :password => 'ie823d63js')
    @project = @ticketmaster.project(@project_id)
    @klass = TicketMaster::Provider::Kanbanpad::Ticket
    @comment_klass = TicketMaster::Provider::Kanbanpad::Comment
  end

  it "should be able to load all tickets" do
    @project.tickets.should be_an_instance_of(Array)
    @project.tickets.first.should be_an_instance_of(@klass)
  end
  
  it "should be able to load all tickets based on an array of ids" do
    @tickets = @project.tickets([@ticket_id])
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.id.should == '4cd428c496f0734eef000007'
  end
  
  it "should be able to load all tickets based on attributes" do
    @tickets = @project.tickets(:id => @ticket_id)
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.id.should == '4cd428c496f0734eef000007'
  end
  
  it "should return the ticket class" do
    @project.ticket.should == @klass
  end
  
  it "should be able to load a single ticket" do
    @ticket = @project.ticket(@ticket_id)
    @ticket.should be_an_instance_of(@klass)
    @ticket.id.should == @ticket_id
  end
  
  it "should be able to load a single ticket based on attributes" do
    @ticket = @project.ticket(:id => @ticket_id)
    @ticket.should be_an_instance_of(@klass)
    @ticket.id.should == @ticket_id
  end

  it "should return nobody as assignee for an empty assignee from the api" do 
    @ticket = @project.ticket(@ticket_id_without_assignee)
    @ticket.assignee.should == 'Nobody'
  end

end
