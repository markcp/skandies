require 'spec_helper'

describe Scene do

  let(:movie) { FactoryGirl.create(:movie) }
  let(:year) { FactoryGirl.create(:year) }
  before { @scene = movie.scenes.build( title: "A scene title", year: year) }

  subject { @scene }

  it { should respond_to(:movie_id) }
  it { should respond_to(:movie) }
  it { should respond_to(:title) }
  it { should respond_to(:year_id) }
  it { should respond_to(:year) }
  it { should respond_to(:points) }
  it { should respond_to(:votes) }

  its(:movie) { should eq movie }
  its(:year) { should eq year }

  it { should be_valid }

  describe "when title is not present" do
    before { @scene.title = nil }
    it { should_not be_valid }
  end

  describe "when movie_id is not present" do
    before { @scene.movie_id = nil }
    it { should_not be_valid }
  end

  describe "when year_id is not present" do
    before { @scene.year_id = nil }
    it { should_not be_valid }
  end
end
