require 'rails_helper'

describe Category do
  it "has a valid factory" do
    expect(FactoryGirl.build(:category)).to be_valid
  end

  it { should validate_presence_of :name }

  describe "complimentary category determination" do
    let!(:actress_category) { create(:category, name: "actress")}
    let!(:supporting_actress_category) { create(:category, name: "supporting actress")}
    let!(:actor_category) { create(:category, name: "actor") }
    let!(:supporting_actor_category) { create(:category, name: "supporting actor") }
    it "returns the correct complimentary_category" do
      expect(actress_category.complementary_category).to eq(supporting_actress_category)
      expect(supporting_actress_category.complementary_category).to eq(actress_category)
      expect(actor_category.complementary_category).to eq(supporting_actor_category)
      expect(supporting_actor_category.complementary_category).to eq(actor_category)
    end
  end

  describe "tiebreaker category determination" do
    let!(:actor_category) { create(:category, name: "actor") }
    let!(:supporting_actor_category) { create(:category, name: "supporting actor") }
    it "should return primary category (Actor or Actress) based on the gender of the given category" do
      expect(actor_category.tiebreaker_category).to eq(actor_category)
      expect(supporting_actor_category.tiebreaker_category).to eq(actor_category)
    end
  end
end
