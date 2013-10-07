require 'spec_helper'

describe TaskMapper::Provider::Kanbanpad::Project do
  let(:project_id) { 'be74b643b64e3dc79aa0' }
  let(:tm) { create_instance }
  let(:project_class) { TaskMapper::Provider::Kanbanpad::Project }

  before do
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/api/v1/projects.json', wheaders, fixture_for('projects'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0.json', wheaders, fixture_for('projects/be74b643b64e3dc79aa0'), 200
    end
  end

  describe "#projects" do
    context "without arguments" do
      let(:projects) { tm.projects }

      it "returns all projects" do
        expect(projects).to be_an Array
        expect(projects.first).to be_a project_class
      end
    end

    context "with an array of project IDs" do
      let(:projects) { tm.projects [project_id] }

      it "returns an array of matching projects" do
        expect(projects).to be_an Array
        expect(projects.length).to eq 1
        expect(projects.first).to be_a project_class
        expect(projects.first.slug).to eq project_id
      end
    end

    context "with a hash containing a project ID" do
      let(:projects) { tm.projects :slug => project_id }

      it "returns an array of matching projects" do
        expect(projects).to be_an Array
        expect(projects.length).to eq 1
        expect(projects.first).to be_a project_class
        expect(projects.first.slug).to eq project_id
      end
    end
  end

  describe "#project" do
    context "with a project ID" do
      let(:project) { tm.project project_id }

      it "returns the relevant project" do
        expect(project).to be_a project_class
        expect(project.slug).to eq project_id
      end
    end
  end
end
