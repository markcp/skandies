require 'spec_helper'

describe Scene do

  let(:movie) { FactoryGirl.create(:movie) }
  before { @scene = movie.scenes.build( title: "A scene title") }

  subject { @scene }

  it { should respond_to(:movie_id) }
  it { should respond_to(:movie) }
  it { should respond_to(:title) }

  its(:movie) { should eq movie }

  it { should be_valid }

  describe "when title is not present" do
    before { @scene.title = nil }
    it { should_not be_valid }
  end

  describe "when movie_id is not present" do
    before { @scene.movie_id = nil }
    it { should_not be_valid }
  end
end
