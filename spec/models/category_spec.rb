require 'spec_helper'

describe Category do

  before { @category = Category.new( name: "Actor") }

  subject { @category }

  it { should respond_to(:name) }

  it { should be_valid }

  describe "when name is not present" do
    before { @category.name = " " }
    it { should_not be_valid }
  end

  describe "#complimentary_category" do
    let!(:actress_category) { FactoryGirl.create(:category, name: "Actress")}
    let!(:supporting_actress_category) { FactoryGirl.create(:category, name: "Supporting Actress")}
    let!(:actor_category) { FactoryGirl.create(:category, name: "Actor") }
    let!(:supporting_actor_category) { FactoryGirl.create(:category, name: "Supporting Actor") }
    it "should return correct complimentary_category" do
      actress_category.complementary_category.should eq(supporting_actress_category)
      supporting_actress_category.complementary_category.should eq(actress_category)
      actor_category.complementary_category.should eq(supporting_actor_category)
      supporting_actor_category.complementary_category.should eq(actor_category)
    end
  end

  describe "#{}tiebreaker_category" do
    let!(:actor_category) { FactoryGirl.create(:category, name: "Actor") }
    let!(:supporting_actor_category) { FactoryGirl.create(:category, name: "Supporting Actor") }
    it "should return correct primary category" do
      actor_category.tiebreaker_category.should eq(actor_category)
      supporting_actor_category.tiebreaker_category.should eq(actor_category)
    end
  end
end
