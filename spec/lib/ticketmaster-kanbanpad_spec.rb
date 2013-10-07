require 'spec_helper'

describe "TaskMapper::Provider::Kanbanpad" do
  let(:headers) { {"Authorization"=>"Basic eWVzOm5v", "Accept"=>"application/json"} }

  before do
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/api/v1/projects.json', headers, fixture_for('projects'), 200
    end
  end

  describe "Provider initializer" do
    subject { TaskMapper.new :kanbanpad, :username => 'blah', :password => 'let' }
    it { should_not be_nil }
  end

  describe "Provider credential validation" do
    subject { TaskMapper.new(:kanbanpad, :username => 'yes', :password => 'no').valid? }
    it { should be_true }
  end


end
