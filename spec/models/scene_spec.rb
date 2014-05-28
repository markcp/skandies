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

  describe "#compute_points_results" do
    let(:scene_with_votes) { FactoryGirl.create(:scene, title: "Scene 1") }
    let(:scene_without_votes) { FactoryGirl.create(:scene, title: "Scene 2")}
    let!(:category) { FactoryGirl.create(:category, name: "Scene") }
    let!(:vote_1) { FactoryGirl.create(:vote, scene: scene_with_votes, credit: nil, category: category, points: 10) }
    let!(:vote_2) { FactoryGirl.create(:vote, scene: scene_with_votes, credit: nil, category: category, points: 5) }

    it "should return the sum of points in a category" do
      scene_with_votes.compute_points.should eq(15)
    end

    it "should return 0 if movie has no votes in the category" do
      scene_without_votes.compute_points.should eq(0)
    end
  end

  describe "#compute_votes" do
    let(:scene_with_votes) { FactoryGirl.create(:scene, title: "Scene 1") }
    let(:scene_without_votes) { FactoryGirl.create(:scene, title: "Scene 2")}
    let!(:category) { FactoryGirl.create(:category, name: "Scene") }
    let!(:vote_1) { FactoryGirl.create(:vote, scene: scene_with_votes, credit: nil, category: category, points: 10) }
    let!(:vote_2) { FactoryGirl.create(:vote, scene: scene_with_votes, credit: nil, category: category, points: 5) }

    it "should return the number of votes in a category" do
      scene_with_votes.compute_votes.should eq(2)
    end

    it "should return 0 if movie has no votes in the category" do
      scene_without_votes.compute_votes.should eq(0)
    end
  end
end
