require 'spec_helper'

describe TopTenEntry do
  let(:ballot) { FactoryGirl.create(:ballot) }
  before { @top_ten_entry = ballot.top_ten_entries.build( value: "A Separation", rank: 0) }

  subject { @top_ten_entry }

  it { should respond_to(:ballot_id) }
  it { should respond_to(:ballot) }
  it { should respond_to(:value) }
  it { should respond_to(:rank) }

  its(:ballot) { should eq ballot }

  it { should be_valid }

  describe "when ballot_id is not present" do
    before { @top_ten_entry.ballot_id = nil }
    it { should_not be_valid }
  end

  describe "when value is not present" do
    before { @top_ten_entry.value = nil }
    it { should_not be_valid }
  end

  describe "when rank is not present" do
    before { @top_ten_entry.rank = nil }
    it { should_not be_valid }
  end

  describe "when rank is too high" do
    before { @top_ten_entry.rank = 11 }
    it { should_not be_valid }
  end
end
