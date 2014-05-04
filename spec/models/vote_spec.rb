require 'spec_helper'

describe Vote do
  let(:ballot) { FactoryGirl.create(:ballot) }
  let(:category) { FactoryGirl.create(:category) }
  let(:credit) { FactoryGirl.create(:credit) }
  let(:movie) { FactoryGirl.create(:movie) }
  before{ @vote = ballot.votes.build(category: category, credit: credit, points: 10) }

  subject { @vote }

  it { should respond_to(:ballot_id) }
  it { should respond_to(:ballot) }
  it { should respond_to(:category_id) }
  it { should respond_to(:category) }
  it { should respond_to(:credit_id) }
  it { should respond_to(:credit) }
  it { should respond_to(:movie_id) }
  it { should respond_to(:movie) }
  it { should respond_to(:value) }
  it { should respond_to(:points) }

  its(:ballot) { should eq ballot }
  its(:category) { should eq category }
  its(:credit) { should eq credit }

  it { should be_valid }

  describe "when voting for a scene" do
    before do
      @vote.credit_id = nil
      @vote.movie_id = movie.id
      @vote.value = "Scene value"
    end
    it { should be_valid }
  end

  describe "when voting for a movie" do
    before do
      @vote.credit_id = nil
      @vote.movie_id = movie.id
      @vote.value = " "
    end
    it { should be_valid }
    its(:movie) { should eq movie }
  end

  describe "when ballot_id is not present" do
    before { @vote.ballot_id = nil }
    it { should_not be_valid }
  end

  describe "when category_id is not present" do
    before { @vote.category_id = nil }
    it { should_not be_valid }
  end

  describe "when credit_id, movie_id, and value are not present" do
    before do
      @vote.credit_id = nil
      @vote.movie_id = nil
      @vote.value = " "
    end
    it { should_not be_valid }
  end

  describe "when points is not present" do
    before { @vote.points = nil }
    it { should_not be_valid }
  end
end
