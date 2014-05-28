require 'spec_helper'

describe Movie do
  let(:year) { FactoryGirl.create(:year) }
  before { @movie = year.movies.new(title: "The Past",
                              director_display: "Asghar Farhadi",
                              screenwriter_display: "Asghar Farhadi") }

  subject { @movie }

  it { should respond_to(:title) }
  it { should respond_to(:title_index) }
  it { should respond_to(:year_id) }
  it { should respond_to(:year) }
  it { should respond_to(:director_display) }
  it { should respond_to(:screenwriter_display) }
  it { should respond_to(:credits) }
  it { should respond_to(:votes) }
  it { should respond_to(:ratings) }
  it { should respond_to(:picture_points) }
  it { should respond_to(:picture_votes) }
  it { should respond_to(:director_points) }
  it { should respond_to(:director_votes) }
  it { should respond_to(:screenplay_points) }
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
  it { should respond_to(:standard_dev) }

  its(:year) { should eq year }

  it { should be_valid }

  describe "when title is not present" do
    before { @movie.title = " " }
    it { should_not be_valid }
  end

  describe "when year_id is not present" do
    before { @movie.year_id = " " }
    it { should_not be_valid }
  end

  describe "title_index" do

    it "should always be computed and present" do
      @movie.title_index = " "
      @movie.save
      expect(@movie).to be_valid
    end

    it "should move initial 'The'" do
      @movie.title = "The Past"
      @movie.save
      expect(@movie.title_index).to eq("Past, The")
    end

    it "should move initial 'A'" do
      @movie.title = "A Separation"
      @movie.save
      expect(@movie.title_index).to eq("Separation, A")
    end

    it "should move initial 'An'" do
      @movie.title = "An Education"
      @movie.save
      expect(@movie.title_index).to eq("Education, An")
    end

    it "should equal title when title doesn't begin with an article" do
      @movie.title = "Upstream Color"
      @movie.save
      expect(@movie.title_index).to eq("Upstream Color")
    end
  end

  describe "#compute_points" do
    let(:movie_with_votes) { FactoryGirl.create(:movie, title: "Movie 1") }
    let(:movie_without_votes) { FactoryGirl.create(:movie, title: "Movie 2")}
    let!(:category) { FactoryGirl.create(:category, name: "Picture") }
    let!(:vote_1) { FactoryGirl.create(:vote, movie: movie_with_votes, credit: nil, category: category, points: 10) }
    let!(:vote_2) { FactoryGirl.create(:vote, movie: movie_with_votes, credit: nil, category: category, points: 5) }

    it "should return the sum of points in a category" do
      movie_with_votes.compute_points(category).should eq(15)
    end

    it "should return 0 if movie has no votes in the category" do
      movie_without_votes.compute_points(category).should eq(0)
    end
  end

  describe "#compute_votes" do
    let(:movie_with_votes) { FactoryGirl.create(:movie, title: "Movie 1") }
    let(:movie_without_votes) { FactoryGirl.create(:movie, title: "Movie 2")}
    let!(:category) { FactoryGirl.create(:category, name: "Picture") }
    let!(:vote_1) { FactoryGirl.create(:vote, movie: movie_with_votes, credit: nil, category: category, points: 10) }
    let!(:vote_2) { FactoryGirl.create(:vote, movie: movie_with_votes, credit: nil, category: category, points: 5) }

    it "should return the number of votes in a category" do
      movie_with_votes.compute_votes(category).should eq(2)
    end

    it "should return 0 if movie has no votes in the category" do
      movie_without_votes.compute_votes(category).should eq(0)
    end
  end

  describe "#compute_average_rating" do
    let!(:movie) { FactoryGirl.create(:movie, title: "Movie 1")}
    let!(:movie_with_no_ratings) { FactoryGirl.create(:movie, title: "Movie with no ratings")}
    let!(:b1) { FactoryGirl.create(:ballot) }
    let!(:b2) { FactoryGirl.create(:ballot) }
    let!(:r1) { FactoryGirl.create(:rating, movie: movie, ballot: b1, value: 2.0)}
    let!(:r2) { FactoryGirl.create(:rating, movie: movie, ballot: b2, value: 2.5)}

    it "should compute the correct average rating" do
      movie.compute_average_rating.should eq(2.25)
    end

    it "should give movies with zero ratings a nil average rating" do
      movie_with_no_ratings.compute_average_rating.should eq(nil)
    end
  end

  describe "#compute_nbr_ratings(value)" do
    let!(:movie) { FactoryGirl.create(:movie, title: "Movie 1:")}
    let!(:movie_with_no_ratings) { FactoryGirl.create(:movie, title: "Movie 2")}
    let!(:b1) { FactoryGirl.create(:ballot) }
    let!(:b2) { FactoryGirl.create(:ballot) }
    let!(:b3) { FactoryGirl.create(:ballot) }
    let!(:r1) { FactoryGirl.create(:rating, movie: movie, ballot: b1, value: 2.0)}
    let!(:r2) { FactoryGirl.create(:rating, movie: movie, ballot: b2, value: 2.5)}
    let!(:r3) { FactoryGirl.create(:rating, movie: movie, ballot: b2, value: 2.5)}

    it "should compute the correct number of ratings" do
      movie.compute_nbr_ratings(2.5).should eq(2)
    end

    it "should handle movies with zero ratings" do
      movie_with_no_ratings.compute_nbr_ratings(2.5).should eq(0)
    end
  end

  describe "compute_standard_dev" do
    let!(:movie) { FactoryGirl.create(:movie, title: "Movie 1:")}
    let!(:movie_with_no_ratings) { FactoryGirl.create(:movie, title: "Movie 2")}
    let!(:b1) { FactoryGirl.create(:ballot) }
    let!(:b2) { FactoryGirl.create(:ballot) }
    let!(:b3) { FactoryGirl.create(:ballot) }
    let!(:r1) { FactoryGirl.create(:rating, movie: movie, ballot: b1, value: 2.0)}
    let!(:r2) { FactoryGirl.create(:rating, movie: movie, ballot: b2, value: 2.5)}
    let!(:r3) { FactoryGirl.create(:rating, movie: movie, ballot: b2, value: 2.5)}

    it "should compute the correct standard dev" do
      movie.compute_standard_dev.should eq(0.29)
    end

    it "should handle movies with zero ratings" do
      movie_with_no_ratings.standard_dev.should eq(nil)
    end
  end
end
