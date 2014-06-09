require 'rails_helper'

describe Vote do

  it "has a valid factory" do
    expect(build(:vote)).to be_valid
  end

  it { should validate_presence_of(:ballot) }
  it { should validate_presence_of(:category) }
  it { should validate_presence_of(:points) }

  describe "vote value object validation" do
    let!(:movie) { create(:movie) }
    let!(:scene) { create(:scene) }
    let!(:credit_vote) { build(:vote) }
    let!(:movie_vote) { build(:vote, credit_id: nil, movie: movie) }
    let!(:scene_vote) { build(:vote, credit_id: nil, scene: scene) }
    let!(:invalid_vote) { build(:vote, credit_id: nil) }

    it "validates credit votes" do
      expect(credit_vote).to be_valid
    end

    it "validates movie votes" do
      expect(movie_vote).to be_valid
    end

    it "validates scene votes" do
      expect(scene_vote).to be_valid
    end

    it "invalidates votes with no object" do
      expect(invalid_vote).not_to be_valid
    end
  end
end
