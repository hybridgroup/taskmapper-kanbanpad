require 'spec_helper'

describe TaskMapper::Provider::Kanbanpad::Project do
  let(:ticket_class) { TaskMapper::Provider::Kanbanpad::Ticket }
  let(:comment_class) { TaskMapper::Provider::Kanbanpad::Comment }
  let(:project_id) { 'be74b643b64e3dc79aa0'}
  let(:ticket_id) { '4cd428c496f0734eef000007'}
  let(:ticket_id_without_note) { '4cd428c496f0734eef000008' }
  let(:ticket_id_without_assignee) { '4dc31c4c9bd0ff6c3700004e' }
  let(:tm) { create_instance }
  let(:project) { tm.project project_id }

  before do
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0.json', wheaders, fixture_for('projects/be74b643b64e3dc79aa0'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0/steps/4dc312f49bd0ff6c37000040/tasks/4cd428c496f0734eef000007.json', wheaders, fixture_for('tasks/4cd428c496f0734eef000007'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0/tasks.json?backlog=yes&finished=yes', headers, fixture_for('tasks'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0/tasks/4cd428c496f0734eef000007.json', headers, fixture_for('tasks/4cd428c496f0734eef000007'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0/tasks/4cd428c496f0734eef000007.json', wheaders, fixture_for('tasks/4cd428c496f0734eef000007'), 200
      mock.get '/api/v1/projects/be74b643b64e3dc79aa0/tasks/4dc31c4c9bd0ff6c3700004e.json', headers, fixture_for('tasks/4dc31c4c9bd0ff6c3700004e'), 200
      mock.post '/api/v1/projects/be74b643b64e3dc79aa0/tasks.json', pheaders, '', 200
      mock.put '/api/v1/projects/be74b643b64e3dc79aa0/steps/4dc312f49bd0ff6c37000040/tasks/4cd428c496f0734eef000007.json', pheaders, fixture_for('tasks/4cd428c496f0734eef000007'), 200
    end
  end

  describe "#tickets" do
    context "with no arguments" do
      let(:tickets) { project.tickets }

      it "returns all tickets" do
        expect(tickets).to be_an Array
        expect(tickets.first).to be_a ticket_class
      end
    end

    context "with an array of ticket IDs" do
      let(:tickets) { project.tickets [ticket_id] }

      it "returns an array containing the requested tickets" do
        expect(tickets).to be_an Array
        expect(tickets.length).to eq 1
        expect(tickets.first).to be_a ticket_class
        expect(tickets.first.id).to eq ticket_id
      end
    end

    context "with an array of ticket IDs" do
      let(:tickets) { project.tickets :id => ticket_id }

      it "returns an array containing the requested ticket" do
        expect(tickets).to be_an Array
        expect(tickets.length).to eq 1
        expect(tickets.first).to be_a ticket_class
        expect(tickets.first.id).to eq ticket_id
      end
    end
  end

  describe "#ticket" do
    context "with a ticket ID" do
      let(:ticket) { project.ticket ticket_id }

      it "returns the requested ticket" do
        expect(ticket).to be_a ticket_class
        expect(ticket.id).to eq ticket_id
      end
    end

    context "with a hash of attributes" do
      let(:ticket) { project.ticket :id => ticket_id }

      it "returns the requested ticket" do
        expect(ticket).to be_a ticket_class
        expect(ticket.id).to eq ticket_id
      end
    end

    describe "a ticket without an assignee" do
      let(:ticket) { project.ticket ticket_id_without_assignee }
      it "sets assignee to 'Nobody'" do
        expect(ticket.assignee).to eq "Nobody"
      end
    end

    describe "#save" do
      let(:ticket) { project.ticket ticket_id }

      it "updates the ticket in Kanbanpad" do
        ticket.title = "Hello World"
        expect(ticket.save).to be_true
        expect(ticket.title).to eq "Hello World"
      end
    end
  end

  describe "#ticket!" do
    context "with a title, assignee, and description" do
      let(:ticket) do
        project.ticket!(
          :title => "New Ticket",
          :assignee => ['john'],
          :description => 'Ticket description'
        )
      end

      it "creates a new Ticket" do
        expect(ticket).to be_a ticket_class
        expect(ticket.title).to eq "New Ticket"
        expect(ticket.assignee).to eq "john"
        expect(ticket[:description]).to eq "Ticket description"
      end
    end
  end
end
