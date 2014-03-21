require 'spec_helper'

describe Movie do
  before { @movie = Movie.new(title: "The Past", year: "2013",
                              director_display: "Asghar Farhadi",
                              screenwriter_display: "Asghar Farhadi") }

  subject { @movie }

  it { should respond_to(:title) }
  it { should respond_to(:title_index) }
  it { should respond_to(:year) }
  it { should respond_to(:director_display) }
  it { should respond_to(:screenwriter_display) }
  it { should respond_to(:credits) }

  it { should be_valid }

  describe "when title is not present" do
    before { @movie.title = " " }
    it { should_not be_valid }
  end

  describe "when year is not present" do
    before { @movie.year = " " }
    it { should_not be_valid }
  end

  describe "when year is too early" do
    before { @movie.year = "1990" }
    it { should_not be_valid }
  end

  describe "when year is too late" do
    before { @movie.year = "2050"}
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
end
