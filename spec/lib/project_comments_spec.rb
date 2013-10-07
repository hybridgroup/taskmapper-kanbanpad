require 'spec_helper'

describe TaskMapper::Provider::Kanbanpad::Comment do
  let(:headers) { {'Authorization' => 'Basic YWJjQGcuY29tOmllODIzZDYzanM='} }
  let(:wheaders) { headers.merge('Accept' => 'application/json') }
  let(:pheaders) { headers.merge("Content-Type" => "application/json") }
  let(:project_id) { 'be74b643b64e3dc79aa0' }
  let(:comment_id) { '4d684e6f973c7d5648000009' }
  let(:tm) { create_instance }
  let(:comment_class) { TaskMapper::Provider::Kanbanpad::Comment }

  describe "Retrieving comments from a project" do
    let(:project) { tm.project project_id }

    context "when calling #comments to a project" do
      subject { project.comments }
      it { should be_instance_of Array }
      it { subject.first.should be_an_instance_of comment_class }
    end
  end

  describe "Creating comments to a project" do
    let(:project) { tm.project project_id }

    context "when calling #comment! to a project instance" do
      subject { project.comment! :body => 'New Project Comment' }
      it { should be_an_instance_of comment_class }
      it { subject.project_id.should_not be_nil }
      it { subject.project_id.should be_a String }
    end
  end
end
