require 'rails_helper'

describe Credit do

  it "has a valid factory" do
    expect(build(:credit)).to be_valid
  end

  it { should validate_presence_of :person }
  it { should validate_presence_of :movie }
  it { should validate_presence_of :job }
  it { should validate_presence_of :year }

  describe "display order" do
    let!(:year) { create(:year) }
    let!(:category) { create(:category) }
    let!(:person1) { create(:person, last_name: "zyx") }
    let!(:person2) { create(:person, last_name: "abc") }
    let!(:person3) { create(:person, last_name: "ttt") }
    let!(:person4) { create(:person, last_name: "sss") }
    let!(:credit1) { create(:credit, person: person1, year: year, points: 25, nbr_votes: 3, category: category) }
    let!(:credit2) { create(:credit, person: person2, year: year, points: 50, nbr_votes: 3, category: category) }
    let!(:credit3) { create(:credit, person: person3, year: year, points: 25, nbr_votes: 4, category: category) }
    let!(:credit4) { create(:credit, person: person4, year: year, points: 25, nbr_votes: 4, category: category) }

    it "returns credits in order by points, number of votes, and person's last name" do
      expect(Credit.results_list(year,category)).to eq([credit2, credit4, credit3, credit1])
    end
  end

  describe "number of votes and points computation by category" do
    let!(:credit) { create(:credit) }
    let!(:actress_category) { create(:category, name: "actress") }
    let!(:actor_category) { create(:category, name: "actor") }
    let!(:v1) { create(:vote, credit: credit, category: actress_category, points: 10) }
    let!(:v2) { create(:vote, credit: credit, category: actress_category, points: 5) }

    context "there are votes in the category" do
      it "returns the vote total in the category" do
        expect(credit.points_by_category(actress_category)).to eq(15)
      end

      it "returns the number of votes in the category" do
        expect(credit.number_of_votes(actress_category)).to eq(2)
      end
    end

    context "there are no votes in the category" do
      it "should return 0 for point total" do
        expect(credit.points_by_category(actor_category)).to eq(0)
      end

      it "should return 0 for number of votes" do
        expect(credit.number_of_votes(actor_category)).to eq(0)
      end
    end
  end

  describe "determination of results category" do
    let!(:credit) { create(:credit) }
    let!(:credit_with_votes_in_two_categories) { create(:credit) }
    let!(:credit_with_equal_number_of_votes_in_two_categories) { create(:credit) }
    let!(:credit_with_equal_number_of_votes_and_points_in_two_categories) { create(:credit) }
    let!(:actress_category) { create(:category, name: "actress") }
    let!(:supporting_actress_category) { create(:category, name: "supporting actress") }
    let!(:v1) { create(:vote, credit: credit, category: supporting_actress_category, points: 10) }
    let!(:v2) { create(:vote, credit: credit_with_votes_in_two_categories, category: supporting_actress_category, points: 10) }
    let!(:v3) { create(:vote, credit: credit_with_votes_in_two_categories, category: supporting_actress_category, points: 5) }
    let!(:v4) { create(:vote, credit: credit_with_votes_in_two_categories, category: actress_category, points: 10)}
    let!(:v5) { create(:vote, credit: credit_with_equal_number_of_votes_in_two_categories, category: supporting_actress_category, points: 5) }
    let!(:v6) { create(:vote, credit: credit_with_equal_number_of_votes_in_two_categories, category: supporting_actress_category, points: 5) }
    let!(:v7) { create(:vote, credit: credit_with_equal_number_of_votes_in_two_categories, category: actress_category, points: 5)}
    let!(:v8) { create(:vote, credit: credit_with_equal_number_of_votes_in_two_categories, category: actress_category, points: 10)}
    let!(:v9) { create(:vote, credit: credit_with_equal_number_of_votes_and_points_in_two_categories, category: supporting_actress_category, points: 10) }
    let!(:v10) { create(:vote, credit: credit_with_equal_number_of_votes_and_points_in_two_categories, category: supporting_actress_category, points: 5) }
    let!(:v11) { create(:vote, credit: credit_with_equal_number_of_votes_and_points_in_two_categories, category: actress_category, points: 7)}
    let!(:v12) { create(:vote, credit: credit_with_equal_number_of_votes_and_points_in_two_categories, category: actress_category, points: 8) }

    context "votes are in one category only" do
      it "returns the category that all votes are in" do
        expect(credit.compute_results_category).to eq(supporting_actress_category)
      end
    end

    context "votes are in two complimentary categories" do
      it "returns the category with the higher number of votes" do
        expect(credit_with_votes_in_two_categories.compute_results_category).to eq(supporting_actress_category)
      end
    end

    context "votes are in two complimentary categories and number of votes in each category are equal" do
      it "returns the category with the higher point total" do
        expect(credit_with_equal_number_of_votes_and_points_in_two_categories.compute_results_category).to eq(actress_category)
      end
    end

    context "votes are in two complimentary categories and number of votes and point total in each category are equal" do
      it "returns the tiebreaker category (actor or actress) for the category/complimentary category pair" do
        expect(credit_with_equal_number_of_votes_and_points_in_two_categories.compute_results_category).to eq(actress_category)
      end
    end
  end

  describe "total points and total number of votes computation for results purposes" do
    let!(:credit) { create(:credit) }
    let!(:credit_with_votes_in_two_categories) { create(:credit) }
    let!(:actress_category) { create(:category, name: "actress") }
    let!(:supporting_actress_category) { create(:category, name: "supporting actress") }
    let!(:v1) { create(:vote, credit: credit, category: supporting_actress_category, points: 10) }
    let!(:v2) { create(:vote, credit: credit, category: supporting_actress_category, points: 5) }
    let!(:v3) { create(:vote, credit: credit_with_votes_in_two_categories, category: supporting_actress_category, points: 10) }
    let!(:v4) { create(:vote, credit: credit_with_votes_in_two_categories, category: supporting_actress_category, points: 5) }
    let!(:v5) { create(:vote, credit: credit_with_votes_in_two_categories, category: actress_category, points: 10) }

    context "votes are in one category only" do
      it "returns the number of votes in that category" do
        expect(credit.compute_votes_results(supporting_actress_category)).to eq(2)
      end

      it "returns the total points in that category" do
        expect(credit.compute_points_results(supporting_actress_category)).to eq(15)
      end
    end

    context "votes are in two complimentary categories" do
      it "returns the total number of votes in both categories" do
        expect(credit_with_votes_in_two_categories.compute_votes_results(supporting_actress_category)).to eq(3)
      end

      it "returns the total points of both categories" do
        expect(credit_with_votes_in_two_categories.compute_points_results(supporting_actress_category)).to eq(25)
      end
    end
  end
end
