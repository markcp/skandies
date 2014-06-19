require 'rails_helper'

describe Vote do

  it "has a valid factory" do
    expect(build(:vote)).to be_valid
  end

  it { should validate_presence_of(:ballot) }
  it { should validate_presence_of(:category) }
  it { should validate_presence_of(:points) }

  describe "display list for movie category pages" do
    let!(:u1) { create(:user, last_name: "zzz") }
    let!(:u2) { create(:user, last_name: "aaa") }
    let!(:u3) { create(:user, last_name: "mmm") }
    let!(:b1) { create(:ballot, user: u1) }
    let!(:b2) { create(:ballot, user: u2) }
    let!(:b3) { create(:ballot, user: u3) }
    let!(:movie) { create(:movie) }
    let!(:picture_category) { create(:category, name: "picture") }
    let!(:v1) { create(:vote, ballot: b1, movie: movie, credit: nil, category: picture_category, points: 10) }
    let!(:v2) { create(:vote, ballot: b2, movie: movie, credit: nil, category: picture_category, points: 10) }
    let!(:v3) { create(:vote, ballot: b3, movie: movie, credit: nil, category: picture_category, points: 5) }

    it "returns the votes in a category by vote points and user last name" do
      expect(Vote.by_points_and_user_name(picture_category)).to eq([v2,v1,v3])
    end
  end

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
