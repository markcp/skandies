require 'spec_helper'

describe Vote do
  let(:ballot) { FactoryGirl.create(:ballot) }
  let(:category) { FactoryGirl.create(:category) }
  let(:credit) { FactoryGirl.create(:credit) }
  let(:movie) { FactoryGirl.create(:movie) }
  before{ @vote = ballot.votes.build(category: category, credit: credit, movie: movie, points: 10) }

  subject { @vote }

  it { should respond_to(:ballot_id) }
  it { should respond_to(:ballot) }
  it { should respond_to(:category_id) }
  it { should respond_to(:category) }
  it { should respond_to(:credit_id) }
  it { should respond_to(:credit) }
  it { should respond_to(:movie_id) }
  it { should respond_to(:movie) }
  it { should respond_to(:points) }

  its(:ballot) { should eq ballot }
  its(:category) { should eq category }
  its(:credit) { should eq credit }
  its(:movie) { should eq movie }

  it { should be_valid }

  describe "when ballot_id is not present" do
    before { @vote.ballot_id = nil }
    it { should_not be_valid }
  end

  describe "when category_id is not present" do
    before { @vote.category_id = nil }
    it { should_not be_valid }
  end

  describe "when credit_id is not present" do
    before { @vote.credit_id = nil }
    it { should be_valid }
  end

  describe "when movie_id is not present" do
    before { @vote.movie_id = nil }
    it { should be_valid }
  end

  describe "when credit_id and movie_id are not present" do
    before do
      @vote.credit_id = nil
      @vote.movie_id = nil
    end
    it { should_not be_valid }
  end

  describe "when points is not present" do
    before { @vote.points = nil }
    it { should_not be_valid }
  end
end
