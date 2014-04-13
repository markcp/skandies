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
end
