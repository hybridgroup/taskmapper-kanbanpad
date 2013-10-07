require 'spec_helper'

describe TaskMapper::Provider::Kanbanpad::Comment do
  let(:headers) { {'Authorization' => 'Basic YWJjQGcuY29tOmllODIzZDYzanM='} }
  let(:wheaders) { headers.merge('Accept' => 'application/json') }
  let(:pheaders) { headers.merge("Content-Type" => "application/json") }
  let(:project_id) { 'be74b643b64e3dc79aa0' }
  let(:ticket_id) { '4cd428c496f0734eef000007' }
  let(:comment_id) { '4d684e6f973c7d5648000009' }
  let(:tm) { create_instance }
  let(:comment_class) { TaskMapper::Provider::Kanbanpad::Comment }
  let(:project) { tm.project project_id }
  let(:ticket) { project.ticket ticket_id }

  describe "Retrieving ticket comments" do
    context "when calling #comments to a ticket instance" do
      subject { ticket.comments }
      it { should be_an_instance_of Array }
      it { subject.first.should be_an_instance_of comment_class }
    end

    context "when calling #comments with an array of comments id's" do
      subject { ticket.comments [comment_id] }
      it { should be_an_instance_of Array }
      it { subject.first.should be_an_instance_of comment_class }
      it { subject.first.id.should be_eql comment_id }
    end

    context "when calling #comments with a hash attributes" do
      subject { ticket.comments :id => comment_id }
      it { should be_an_instance_of Array }
      it { subject.first.should be_an_instance_of comment_class }
      it { subject.first.id.should be_eql comment_id }
    end

  end

  describe "Comment creation to a ticket" do
    context "when calling #comment! to a ticket instance" do
      subject { ticket.comment! :body => 'New Ticket' }
      it { should be_an_instance_of comment_class }
      it { subject.ticket_id.should_not be_nil }
      it { subject.ticket_id.should_not be_eql 0 }
    end
  end

end
