require 'rails_helper'

describe Scene do

  it "has a valid factory" do
    expect(build(:scene)).to be_valid
  end

  it { should validate_presence_of :movie }
  it { should validate_presence_of :title }
  it { should validate_presence_of :year }

  describe "provides a list of results for the scene category results page" do
    let!(:year) { create(:year) }
    let!(:s1) { create(:scene, year: year, points: 10, nbr_votes: 2, title: "zzz") }
    let!(:s2) { create(:scene, year: year, points: 10, nbr_votes: 2, title: "aaa") }
    let!(:s3) { create(:scene, year: year, points: 20, nbr_votes: 4, title: "ttt") }
    let!(:s4) { create(:scene, year: year, points: 20, nbr_votes: 5, title: "sss") }

    it "returns scenes in category results order by points, number of votes, and title" do
      expect(Scene.results_list(year)).to eq([s4,s3,s2,s1])
    end
  end

  describe "total points and number of votes computation" do
    let(:scene_with_votes) { create(:scene, title: "Scene 1") }
    let(:scene_without_votes) { create(:scene, title: "Scene 2")}
    let!(:category) { create(:category, name: "Scene") }
    let!(:vote_1) { create(:vote, scene: scene_with_votes, credit: nil, category: category, points: 10) }
    let!(:vote_2) { create(:vote, scene: scene_with_votes, credit: nil, category: category, points: 5) }

    context "scene has votes" do
      it "returns the total points" do
        expect(scene_with_votes.compute_points).to eq(15)
      end

      it "returns the number of votes" do
        expect(scene_with_votes.compute_votes).to eq(2)
      end
    end

    context "scene has no votes" do
      it "returns 0 for total points" do
        expect(scene_without_votes.compute_points).to eq(0)
      end

      it "returns 0 for number of votes" do
        expect(scene_without_votes.compute_votes).to eq(0)
      end
    end
  end
end
