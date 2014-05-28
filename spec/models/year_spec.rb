require 'spec_helper'

describe Year do

  before{ @year = Year.new(name: "2013") }
  subject { @year }

  it { should respond_to(:name) }
  it { should respond_to(:open_voting) }
  it { should respond_to(:close_voting) }
  it { should respond_to(:display_results) }
  it { should respond_to(:movies) }
  it { should respond_to(:ballots) }

  it { should be_valid }

  describe "when name is not present" do
    before { @year.name = " " }
    it { should_not be_valid }
  end

  describe "when open_voting is not present" do
    before { @year.open_voting = " " }
    it { should_not be_valid }
  end

  describe "when close_voting is not present" do
    before { @year.close_voting = " " }
    it { should_not be_valid }
  end

  describe "when display_results is not present" do
    before { @year.display_results = " " }
    it { should_not be_valid }
  end

  it "should contain a default value in open_voting" do
    @year.save
    expect(@year.open_voting).to eq("2001-01-01 00:00:00")
  end

  it "should contain a default value in close_voting" do
    @year.save
    expect(@year.close_voting).to eq("2001-01-01 00:00:00")
  end

  it "should contain a default value in display_results" do
    @year.save
    expect(@year.display_results).to eq("2001-01-01 00:00:00")
  end

  describe "#ranked_movies_hash" do
    let!(:year) { FactoryGirl.create(:year) }
    let!(:tied_movie1) { FactoryGirl.create(:movie, year: year, nbr_ratings: 5, average_rating: 2.00) }
    let!(:movie1) { FactoryGirl.create(:movie, year: year, nbr_ratings: 5, average_rating: 3.00) }
    let!(:movie2) { FactoryGirl.create(:movie, year: year, nbr_ratings: 5, average_rating: 1.00) }
    let!(:tied_movie2) { FactoryGirl.create(:movie, year: year, nbr_ratings: 5, average_rating: 2.00) }
    let!(:movie_with_too_few_votes) { FactoryGirl.create(:movie, year: year, nbr_ratings: 4, average_rating: 2.00) }
    let!(:ranked_movies_hash) { year.ranked_movies_hash }

    it "should rank movies correctly" do
      ranked_movies_hash[movie1.id].should eq(1)
    end

    it "should handle tied movies" do
      ranked_movies_hash[tied_movie1.id].should eq(2.5)
      ranked_movies_hash[tied_movie2.id].should eq(2.5)
    end

    it "should skip tied ranks correctly" do
      ranked_movies_hash[movie2.id].should eq(nil)
    end

    it "should not rank movies with fewer than 5 votes" do
      ranked_movies_hash[movie_with_too_few_votes.id].should eq(nil)
    end
  end
end
