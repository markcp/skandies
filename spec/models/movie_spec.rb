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
    let!(:picture_category) { FactoryGirl.create(:category, name: "Picture") }
    let!(:director_category) { FactoryGirl.create(:category, name: "Director") }
    let!(:screenplay_category) { FactoryGirl.create(:category, name: "Screenplay")}
    let!(:picture_vote_1) { FactoryGirl.create(:vote, movie: movie_with_votes, credit: nil, category: picture_category, points: 10) }
    let!(:picture_vote_2) { FactoryGirl.create(:vote, movie: movie_with_votes, credit: nil, category: picture_category, points: 5) }
    let!(:director_vote_1) { FactoryGirl.create(:vote, movie: movie_with_votes, credit: nil, category: director_category, points: 10) }
    let!(:director_vote_2) { FactoryGirl.create(:vote, movie: movie_with_votes, credit: nil, category: director_category, points: 5) }
    let!(:screenplay_vote_1) { FactoryGirl.create(:vote, movie: movie_with_votes, credit: nil, category: screenplay_category, points: 10) }
    let!(:screenplay_vote_2) { FactoryGirl.create(:vote, movie: movie_with_votes, credit: nil, category: screenplay_category, points: 5) }

    it "should compute the correct number of best picture points" do
      movie_with_votes.compute_points(picture_category).should eq(15)
    end

    it "should return 0 if movie has no best picture votes" do
      movie_without_votes.compute_points(picture_category).should eq(0)
    end

    it "should compute the correct number of best director points" do
      movie_with_votes.compute_points(director_category).should eq(15)
    end

    it "should return 0 if movie has no best director votes" do
      movie_without_votes.compute_points(director_category).should eq(0)
    end

    it "should compute the correct number of best screenwriter points" do
      movie_with_votes.compute_points(screenplay_category).should eq(15)
    end

    it "should return 0 if movie has no best screenplay votes" do
      movie_without_votes.compute_points(screenplay_category).should eq(0)
    end
  end
end
