require 'spec_helper'

describe TaskMapper::Provider::Kanbanpad::Project do
  let(:project_id) { 'be74b643b64e3dc79aa0' }
  let(:comment_id) { '4d684e6f973c7d5648000009' }
  let(:tm) { create_instance }
  let(:project) { tm.project project_id }
  let(:comment_class) { TaskMapper::Provider::Kanbanpad::Comment }

  before do
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0.json', wheaders, fixture_for('projects/be74b643b64e3dc79aa0'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0/comments.json', wheaders, fixture_for('comments'), 200
      mock.post '/api/v1/projects/be74b643b64e3dc79aa0/comments.json', pheaders, '', 200
    end
  end

  describe "#comments" do
    describe "without arguments" do
      let(:comments) { project.comments }

      it "returns all projects on the project" do
        expect(comments).to be_an Array
        expect(comments.first).to be_a comment_class
      end
    end
  end

  describe "#comment!" do
    context "with a comment body" do
      let(:comment) { project.comment! :body => "New Project Comment" }

      it "creates a new comment belonging to the project" do
        expect(comment).to be_a comment_class
        expect(comment.project_id).to eq project.id
        expect(comment.body).to eq "New Project Comment"
      end
    end
  end
end
