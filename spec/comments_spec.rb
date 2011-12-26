require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TicketMaster::Provider::Kanbanpad::Comment do
  before(:all) do
    headers = {'Authorization' => 'Basic YWJjQGcuY29tOmllODIzZDYzanM='}
    wheaders = headers.merge('Accept' => 'application/json')
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0.json', wheaders, fixture_for('projects/be74b643b64e3dc79aa0'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0/tasks.json', wheaders, fixture_for('tasks'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0/tasks.json?backlog=yes&finished=yes', wheaders, fixture_for('tasks'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0/tasks/4cd428c496f0734eef000007.json', wheaders, fixture_for('tasks/4cd428c496f0734eef000007'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0/tasks/4cd428c496f0734eef000007/comments.json', wheaders, fixture_for('comments'), 200
      mock.post '/api/v1/projects/be74b643b64e3dc79aa0/steps/4dc312f49bd0ff6c37000040/tasks/4cd428c496f0734eef000007/comments.json', wheaders, fixture_for('comments/4ef2719bf17365000110df9e'), 200
    end
    @project_id = 'be74b643b64e3dc79aa0'
    @ticket_id = '4cd428c496f0734eef000007'
    @comment_id = '4d684e6f973c7d5648000009'
  end

  before(:each) do
    @ticketmaster = TicketMaster.new(:kanbanpad, :username => 'abc@g.com', :password => 'ie823d63js')
    @project = @ticketmaster.project(@project_id)
    @ticket = @project.ticket(@ticket_id)
    @klass = TicketMaster::Provider::Kanbanpad::Comment
  end

  it "should be able to load all comments" do 
    @comments = @ticket.comments
    @comments.should be_an_instance_of(Array)
    @comments.first.should be_an_instance_of(@klass)
  end

  it "should be able to load all comments based on array of id's" do 
    @comments = @ticket.comments([@comment_id])
    @comments.should be_an_instance_of(Array)
    @comments.first.should be_an_instance_of(@klass)
  end

  it "should be able to load all comments based on attributes" do 
    @comments = @ticket.comments(:id => @comment_id)
    @comments.should be_an_instance_of(Array)
    @comments.first.should be_an_instance_of(@klass)
  end

  it "should be able to create a comment for a given task" do
    pending
    @comment = @ticket.comment!(:body => "New Ticket")
    @comment.should be_an_instance_of(@klass)
  end

end
