require 'spec_helper'

describe "TaskMapper::Provider::Kanbanpad" do
  let(:headers) { {"Authorization"=>"Basic eWVzOm5v", "Accept"=>"application/json"} }

  describe "Provider initializer" do
    subject { create_instance }
    it { should_not be_nil }
  end

  describe "Provider credential validation" do
    subject { create_instance }
    it { should be_true }
  end


end
