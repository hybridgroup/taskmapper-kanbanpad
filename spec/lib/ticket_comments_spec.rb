require 'spec_helper'

describe TaskMapper::Provider::Kanbanpad::Ticket do
  let(:project_id) { 'be74b643b64e3dc79aa0' }
  let(:ticket_id) { '4cd428c496f0734eef000007' }
  let(:comment_id) { '4d684e6f973c7d5648000009' }
  let(:comment_class) { TaskMapper::Provider::Kanbanpad::Comment }
  let(:tm) { create_instance }
  let(:project) { tm.project project_id }
  let(:ticket) { project.ticket ticket_id }

  before(:each) do
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0.json', wheaders, fixture_for('projects/be74b643b64e3dc79aa0'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0/tasks/4cd428c496f0734eef000007.json', wheaders, fixture_for('tasks/4cd428c496f0734eef000007'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0/tasks/4cd428c496f0734eef000007/comments.json', wheaders, fixture_for('comments'), 200
      mock.post '/api/v1/projects/be74b643b64e3dc79aa0/steps/4dc312f49bd0ff6c37000040/tasks/4cd428c496f0734eef000007/comments.json', pheaders, '', 200
    end
  end

  describe "#comments" do
    context "without arguments" do
      let(:comments) { ticket.comments }

      it "returns an array of all comments" do
        expect(comments).to be_an Array
        expect(comments.first).to be_a comment_class
      end
    end

    context "with an array of comment IDs" do
      let(:comments) { ticket.comments [comment_id] }

      it "returns an array of matching comments" do
        expect(comments).to be_an Array
        expect(comments.length).to eq 1
        expect(comments.first).to be_a comment_class
        expect(comments.first.id).to eq comment_id
      end
    end

    context "with a hash containing a comment ID" do
      let(:comments) { ticket.comments :id => comment_id }

      it "returns an array containing the matching comment" do
        expect(comments).to be_an Array
        expect(comments.length).to eq 1
        expect(comments.first).to be_a comment_class
        expect(comments.first.id).to eq comment_id
      end
    end
  end

  describe "#comment" do
    context "with a comment ID" do
      let(:comment) { ticket.comment comment_id }

      it "returns the matching comment" do
        expect(comment).to be_a comment_class
        expect(comment.id).to eq comment_id
      end
    end
  end

  describe "#comment!" do
    context "with a comment body" do
      let(:comment) { ticket.comment! :body => "New Ticket" }

      it "creates a new comment on the ticket" do
        expect(comment).to be_a comment_class
        expect(comment.body).to eq "New Ticket"
        expect(comment.ticket_id).to eq ticket.id
      end
    end
  end
end
