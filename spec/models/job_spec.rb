require 'spec_helper'

describe Job do
  before { @job = Job.new(name: "director") }

  subject { @job }

  it { should respond_to(:name) }
  it { should respond_to(:credits) }

  it { should be_valid }

  describe "when name is not present" do
    before { @job.name = " " }
    it { should_not be_valid }
  end
end
