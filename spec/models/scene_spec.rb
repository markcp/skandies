require 'rails_helper'

describe Scene do

  it "has a valid factory" do
    expect(build(:scene)).to be_valid
  end

  it { should validate_presence_of :movie }
  it { should validate_presence_of :title }
  it { should validate_presence_of :year }

  it "provides a results display format" do
    scene = build_stubbed(:scene, points: 100, nbr_votes: 10)
    expect(scene.results_display).to eq("A stirring scene, The Past 100/10")
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
