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
  it { should respond_to(:nbr_ratings) }
  it { should respond_to(:average_rating) }
  it { should respond_to(:four_ratings) }
  it { should respond_to(:three_pt_five_ratings) }
  it { should respond_to(:three_ratings) }
  it { should respond_to(:two_pt_five_ratings) }
  it { should respond_to(:two_ratings) }
  it { should respond_to(:one_pt_five_ratings) }
  it { should respond_to(:one_ratings) }
  it { should respond_to(:zero_ratings) }
  it { should respond_to(:selectivity_index) }

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

  describe "#compute_total_nbr_ratings" do
    let!(:ballot) { FactoryGirl.create(:ballot)}
    let!(:ballot_with_no_ratings) { FactoryGirl.create(:ballot) }
    let!(:r1) { FactoryGirl.create(:rating, ballot: ballot) }
    let!(:r2) { FactoryGirl.create(:rating, ballot: ballot) }

    it "should compute the correct number of ratings" do
      ballot.compute_total_nbr_ratings.should eq(2)
    end

    it "should handle ballots with zero ratings" do
      ballot_with_no_ratings.compute_total_nbr_ratings.should eq(0)
    end
  end

  describe "#compute_average_rating" do
    let!(:ballot) { FactoryGirl.create(:ballot)}
    let!(:ballot_with_no_ratings) { FactoryGirl.create(:ballot) }
    let!(:r1) { FactoryGirl.create(:rating, ballot: ballot, value: 2.0) }
    let!(:r2) { FactoryGirl.create(:rating, ballot: ballot, value: 2.5) }

    it "should compute the correct number of ratings" do
      ballot.compute_average_rating.should eq(2.25)
    end

    it "should handle ballots with zero ratings" do
      ballot_with_no_ratings.compute_average_rating.should eq(nil)
    end
  end

  describe "#compute_nbr_ratings(value)" do
    let!(:ballot) { FactoryGirl.create(:ballot)}
    let!(:ballot_with_no_ratings) { FactoryGirl.create(:ballot) }
    let!(:r1) { FactoryGirl.create(:rating, ballot: ballot, value: 2.0) }
    let!(:r2) { FactoryGirl.create(:rating, ballot: ballot, value: 2.5) }
    let!(:r3) { FactoryGirl.create(:rating, ballot: ballot, value: 2.5) }

    it "should compute the correct number of ratings" do
      ballot.compute_nbr_ratings(2.5).should eq(2)
    end

    it "should handle ballots with zero ratings" do
      ballot_with_no_ratings.compute_nbr_ratings(2.5).should eq(0)
    end
  end

end
