require 'spec_helper'

describe Credit do

  let(:movie) { FactoryGirl.create(:movie) }
  let(:person) { FactoryGirl.create(:person) }
  let(:job) { FactoryGirl.create(:job) }
  let(:year) { FactoryGirl.create(:year) }
  let(:category) { FactoryGirl.create(:category) }
  before { @credit = movie.credits.build( person: person, job: job, year: year,
                                          category: category) }

  subject { @credit }

  it { should respond_to(:person_id) }
  it { should respond_to(:person) }
  it { should respond_to(:movie_id) }
  it { should respond_to(:movie) }
  it { should respond_to(:job_id) }
  it { should respond_to(:job) }
  it { should respond_to(:year_id) }
  it { should respond_to(:year) }
  it { should respond_to(:votes) }
  it { should respond_to(:results_category_id) }
  it { should respond_to(:category) }
  it { should respond_to(:points) }
  it { should respond_to(:votes) }

  its(:person) { should eq person }
  its(:movie) { should eq movie }
  its(:job) { should eq job }
  its(:year) { should eq year }
  its(:results_category_id) { should eq category.id }

  it { should be_valid }

  describe "when person_id is not present" do
    before { @credit.person_id = nil }
    it { should_not be_valid }
  end

  describe "when movie_id is not present" do
    before { @credit.movie_id = nil }
    it { should_not be_valid }
  end

  describe "when job_id is not present" do
    before { @credit.job_id = nil }
    it { should_not be_valid }
  end

  describe "when year_id is not present" do
    before { @credit.year_id = nil }
    it { should_not be_valid }
  end

  describe "#compute_results_category" do
    let(:credit) { FactoryGirl.create(:credit) }
    let(:credit_with_votes_in_two_categories) { FactoryGirl.create(:credit) }
    let(:credit_with_equal_number_of_votes_in_two_categories) { FactoryGirl.create(:credit) }
    let(:credit_with_equal_number_of_votes_and_points_in_two_categories) { FactoryGirl.create(:credit) }
    let(:actress_category) { FactoryGirl.create(:category, name: "Actress") }
    let(:supporting_actress_category) { FactoryGirl.create(:category, name: "Supporting Actress") }
    let!(:v1) { FactoryGirl.create(:vote, credit: credit, category: supporting_actress_category, points: 10) }
    let!(:v2) { FactoryGirl.create(:vote, credit: credit, category: supporting_actress_category, points: 5) }
    let!(:v3) { FactoryGirl.create(:vote, credit: credit_with_votes_in_two_categories, category: supporting_actress_category, points: 10) }
    let!(:v4) { FactoryGirl.create(:vote, credit: credit_with_votes_in_two_categories, category: supporting_actress_category, points: 5) }
    let!(:v5) { FactoryGirl.create(:vote, credit: credit_with_votes_in_two_categories, category: actress_category, points: 10)}
    let!(:v6) { FactoryGirl.create(:vote, credit: credit_with_equal_number_of_votes_in_two_categories, category: supporting_actress_category, points: 10) }
    let!(:v7) { FactoryGirl.create(:vote, credit: credit_with_equal_number_of_votes_in_two_categories, category: supporting_actress_category, points: 5) }
    let!(:v8) { FactoryGirl.create(:vote, credit: credit_with_equal_number_of_votes_in_two_categories, category: actress_category, points: 10)}
    let!(:v9) { FactoryGirl.create(:vote, credit: credit_with_equal_number_of_votes_in_two_categories, category: actress_category, points: 10) }
    let!(:v10) { FactoryGirl.create(:vote, credit: credit_with_equal_number_of_votes_and_points_in_two_categories, category: supporting_actress_category, points: 10) }
    let!(:v11) { FactoryGirl.create(:vote, credit: credit_with_equal_number_of_votes_and_points_in_two_categories, category: supporting_actress_category, points: 5) }
    let!(:v12) { FactoryGirl.create(:vote, credit: credit_with_equal_number_of_votes_and_points_in_two_categories, category: actress_category, points: 10)}
    let!(:v13) { FactoryGirl.create(:vote, credit: credit_with_equal_number_of_votes_and_points_in_two_categories, category: actress_category, points: 10) }
    let!(:v14) { FactoryGirl.create(:vote, credit: credit_with_equal_number_of_votes_and_points_in_two_categories, category: supporting_actress_category, points: 10) }
    let!(:v15) { FactoryGirl.create(:vote, credit: credit_with_equal_number_of_votes_and_points_in_two_categories, category: actress_category, points: 5) }

    it "should return correct category when votes are in one category only" do
      credit.compute_results_category.should eq(supporting_actress_category)
    end

    it "should return category with higher number of votes when votes are in two complementary categories" do
      credit_with_votes_in_two_categories.compute_results_category.should eq(supporting_actress_category)
    end

    it "should return category with higher point total when two category vote totals are equal" do
      credit_with_equal_number_of_votes_and_points_in_two_categories.compute_results_category.should eq(actress_category)
    end

    it "should return primary category when two category vote totals and point totals are equal" do
      credit_with_equal_number_of_votes_and_points_in_two_categories.compute_results_category.should eq(actress_category)
    end
  end

  describe "#compute_votes_results" do
    let(:credit) { FactoryGirl.create(:credit) }
    let(:credit_with_votes_in_two_categories) { FactoryGirl.create(:credit) }
    let!(:actress_category) { FactoryGirl.create(:category, name: "Actress") }
    let!(:supporting_actress_category) { FactoryGirl.create(:category, name: "Supporting Actress") }
    let!(:v1) { FactoryGirl.create(:vote, credit: credit, category: supporting_actress_category, points: 10) }
    let!(:v2) { FactoryGirl.create(:vote, credit: credit, category: supporting_actress_category, points: 5) }
    let!(:v3) { FactoryGirl.create(:vote, credit: credit_with_votes_in_two_categories, category: supporting_actress_category, points: 10) }
    let!(:v4) { FactoryGirl.create(:vote, credit: credit_with_votes_in_two_categories, category: supporting_actress_category, points: 5) }
    let!(:v5) { FactoryGirl.create(:vote, credit: credit_with_votes_in_two_categories, category: actress_category, points: 10) }
    it "should return correct total" do
      credit.compute_votes_results(supporting_actress_category).should eq(2)
    end
    it "should return correct total when votes are in two complementary categories" do
      credit_with_votes_in_two_categories.compute_votes_results(supporting_actress_category).should eq(3)
    end
  end

  describe "#compute_points_results" do
    let(:credit) { FactoryGirl.create(:credit) }
    let(:credit_with_votes_in_two_categories) { FactoryGirl.create(:credit) }
    let!(:actress_category) { FactoryGirl.create(:category, name: "Actress") }
    let!(:supporting_actress_category) { FactoryGirl.create(:category, name: "Supporting Actress") }
    let!(:v1) { FactoryGirl.create(:vote, credit: credit, category: supporting_actress_category, points: 10) }
    let!(:v2) { FactoryGirl.create(:vote, credit: credit, category: supporting_actress_category, points: 5) }
    let!(:v3) { FactoryGirl.create(:vote, credit: credit_with_votes_in_two_categories, category: supporting_actress_category, points: 10) }
    let!(:v4) { FactoryGirl.create(:vote, credit: credit_with_votes_in_two_categories, category: supporting_actress_category, points: 5) }
    let!(:v5) { FactoryGirl.create(:vote, credit: credit_with_votes_in_two_categories, category: actress_category, points: 10) }
    it "should return correct total" do
      credit.compute_points_results(supporting_actress_category).should eq(15)
    end
    it "should return correct total when votes are in two complementary categories" do
      credit_with_votes_in_two_categories.compute_points_results(supporting_actress_category).should eq(25)
    end
  end
end
