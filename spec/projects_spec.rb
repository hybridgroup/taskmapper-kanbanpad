require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Kanbanpad::Project do
  let(:headers) { {'Authorization' => 'Basic YWJjQGcuY29tOmllODIzZDYzanM='} }
  let(:wheaders) { headers.merge('Accept' => 'application/json') }
  let(:project_id) { 'be74b643b64e3dc79aa0' }
  let(:tm) { TaskMapper.new(:kanbanpad, :username => 'abc@g.com', :password => 'ie823d63js') }
  let(:project_class) { TaskMapper::Provider::Kanbanpad::Project }

  describe "Retrieving projects" do
    before(:each) do
      ActiveResource::HttpMock.respond_to do |mock|
        mock.get '/api/v1/projects.json', wheaders, fixture_for('projects'), 200
        mock.get '/api/v1/projects/be74b643b64e3dc79aa0.json', wheaders, fixture_for('projects/be74b643b64e3dc79aa0'), 200
      end
    end

    context "when calling #projects on a TaskMapper instance" do
      subject { tm.projects }
      it { should be_an_instance_of Array }
      it { subject.first.should be_an_instance_of project_class }
    end

    context "when calling #projects on a TaskMapper instance with an array of project's id" do
      subject { tm.projects([project_id]) }
      it { should be_an_instance_of Array }
      it { subject.first.should be_an_instance_of project_class }
      it { subject.first.slug.should be_eql project_id }
    end

    context "when calling #projects on a TaskMapper instance passing a hash of attributes" do
      subject { tm.projects :slug => project_id }
      it { should be_an_instance_of Array }
      it { subject.first.should be_an_instance_of project_class }
      it { subject.first.slug.should be_eql project_id }
    end

    context "when calling #project with a project slug" do
      subject { tm.project project_id }
      it { should be_an_instance_of project_class }
      it { subject.slug.should be_eql project_id }
    end
  end
end
