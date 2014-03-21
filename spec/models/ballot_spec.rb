require 'spec_helper'

describe Ballot do

  let(:user) { FactoryGirl.create(:user) }
  let(:year) { FactoryGirl.create(:year) }
  before { @ballot = user.ballots.build( year: year) }

  subject { @ballot }

  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:year_id) }
  it { should respond_to(:year) }
  it { should respond_to(:complete)}

  its(:user) { should eq user }
  its(:year) { should eq year }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @ballot.user_id = nil }
    it { should_not be_valid }
  end

  describe "when year_id is not present" do
    before { @ballot.year_id = nil }
    it { should_not be_valid }
  end

  describe "when completed is not present" do
    before { @ballot.complete = nil }
    it { should_not be_valid }
  end

  it "should use a default value for complete" do
    @ballot.save
    expect(@ballot.complete).to eq(false)
  end
end
