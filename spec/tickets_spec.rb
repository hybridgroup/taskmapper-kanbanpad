require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Kanbanpad::Ticket do
  let(:headers) { {'Authorization' => 'Basic YWJjQGcuY29tOmllODIzZDYzanM='} }
  let(:wheaders) { headers.merge('Accept' => 'application/json') }
  let(:pheaders) { headers.merge("Content-Type" => "application/json") }
  let(:ticket_data) { {:tasks => {:title => 'new ticket'}} }
  let(:project_id) { 'be74b643b64e3dc79aa0'}
  let(:ticket_id) { '4cd428c496f0734eef000007'}
  let(:ticket_id_without_note) { '4cd428c496f0734eef000008' }
  let(:ticket_id_without_assignee) { '4dc31c4c9bd0ff6c3700004e' }
  let(:tm) { TaskMapper.new(:kanbanpad, :username => 'abc@g.com', :password => 'ie823d63js') }
  let(:ticket_class) { TaskMapper::Provider::Kanbanpad::Ticket }
  let(:comment_class) { TaskMapper::Provider::Kanbanpad::Comment }

  describe "Retrieving tickets" do
    before(:each) do
      ActiveResource::HttpMock.respond_to do |mock|
        mock.get '/api/v1/projects/be74b643b64e3dc79aa0.json', wheaders, fixture_for('projects/be74b643b64e3dc79aa0'), 200
        mock.get '/api/v1/projects/be74b643b64e3dc79aa0/tasks.json?backlog=yes&finished=yes', headers, fixture_for('tasks'), 200
        mock.get '/api/v1/projects/be74b643b64e3dc79aa0/tasks/4cd428c496f0734eef000007.json', headers, fixture_for('tasks/4cd428c496f0734eef000007'), 200
        mock.get '/api/v1/projects/be74b643b64e3dc79aa0/tasks/4dc31c4c9bd0ff6c3700004e.json', headers, fixture_for('tasks/4dc31c4c9bd0ff6c3700004e'), 200
      end
    end
    let(:project) { tm.project project_id }

    context "when calling #tickets on a project instance" do
      subject { project.tickets }
      it { should be_an_instance_of Array }
      it { subject.first.should be_an_instance_of ticket_class }
    end

    context "when calling #tickets with an array of ticket id's" do
      subject { project.tickets([ticket_id]) }
      it { should be_an_instance_of Array }
      it { subject.first.should be_an_instance_of ticket_class }
      it { subject.first.id.should be_eql ticket_id }
    end

    context "when calling #tickets with a hash attributes" do
      subject { project.tickets :id => ticket_id }
      it { should be_an_instance_of Array }
      it { subject.first.should be_an_instance_of ticket_class }
      it { subject.first.id.should be_eql ticket_id }
    end

    describe "Retrieve a single ticket" do
      context "when calling #ticket with a ticket id" do
        subject { project.ticket ticket_id }
        it { should be_an_instance_of ticket_class }
        it { subject.id.should be_eql ticket_id }
      end

      context "when calling #ticket with a hash attribute" do
        subject { project.ticket :id => ticket_id }
        it { should be_an_instance_of ticket_class }
        it { subject.id.should be_eql ticket_id }
      end

      context "when retrieving a ticket without assignee" do
        subject { project.ticket ticket_id_without_assignee }
        it { subject.assignee.should be_eql 'Nobody' }
      end

      context "when retrieving a ticket" do
        subject { project.ticket ticket_id }
        its(:id) { should be_eql '4cd428c496f0734eef000007' }
        its(:status) { should be_eql 'Finished' }
        its(:priority) { should be_eql 'Not Urgent' }
        its(:resolution) { should be_nil }
        its(:title) { should be_eql 'Fix UI detail' }
        its(:created_at) { should_not be_nil }
        its(:updated_at) { should_not be_nil }
        its(:description) { should be_nil }
        its(:requestor) { should be_nil }
        its(:project_id) { should be_eql 'be74b643b64e3dc79aa0' }
        its(:assignee) { should be_eql 'Rafael George' }
      end
    end
  end

  describe "Create and Update tickets" do
    before(:each) do
      ActiveResource::HttpMock.respond_to do |mock|
        mock.get '/api/v1/projects/be74b643b64e3dc79aa0.json', wheaders, fixture_for('projects/be74b643b64e3dc79aa0'), 200
        mock.get '/api/v1/projects/be74b643b64e3dc79aa0/tasks/4cd428c496f0734eef000007.json', wheaders, fixture_for('tasks/4cd428c496f0734eef000007'), 200
        mock.get '/api/v1/projects/be74b643b64e3dc79aa0/steps/4dc312f49bd0ff6c37000040/tasks/4cd428c496f0734eef000007.json', wheaders, fixture_for('tasks/4cd428c496f0734eef000007'), 200
        mock.post '/api/v1/projects/be74b643b64e3dc79aa0/tasks.json', pheaders, '', 200
        mock.put '/api/v1/projects/be74b643b64e3dc79aa0/steps/4dc312f49bd0ff6c37000040/tasks/4cd428c496f0734eef000007.json', pheaders, fixture_for('tasks/4cd428c496f0734eef000007'), 200
      end
    end
    let(:project) { tm.project project_id }

    context "when calling #ticket! to a project instance" do
      subject { project.ticket! :title => 'New Ticket', :assignee => ['john'], :description => 'Ticket description' }
      it { should be_an_instance_of ticket_class }
    end

    context "when calling #save to a ticket instance and a field is change" do
      it "should update the ticket instance in the backend" do
        ticket = project.ticket ticket_id
        ticket.title = 'Hello World'
        ticket.save.should be_true
      end
    end
  end
end
