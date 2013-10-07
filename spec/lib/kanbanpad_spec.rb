require 'spec_helper'

describe TaskMapper::Provider::Kanbanpad do
  let(:tm) { create_instance }

  before do
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/api/v1/projects.json', headers, fixture_for('projects'), 200
    end
  end

  describe "#new" do
    it "creates a new TaskMapper instance" do
      expect(tm).to be_a TaskMapper
    end

    it "can be explicitly called as a provider" do
      tm = TaskMapper::Provider::Kanbanpad.new(
        :username => username,
        :password => password
      )

      expect(tm).to be_a TaskMapper
    end
  end

  describe "#valid?" do
    context "with a correctly authenticated Kanbanpad user" do
      it "returns true" do
        expect(tm.valid?).to be_true
      end
    end
  end
end
