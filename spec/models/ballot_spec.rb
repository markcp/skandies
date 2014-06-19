require 'rails_helper'

describe Ballot do

  it "has a valid factory" do
    expect(build(:ballot)).to be_valid
  end

  it { should validate_presence_of :user }
  it { should validate_presence_of :year }

  describe "display order" do
    let!(:year) { create(:year) }
    let!(:user1) { create(:user, last_name: "sss") }
    let!(:user2) { create(:user, last_name: "zyx") }
    let!(:user3) { create(:user, last_name: "abc") }
    let!(:ballot1) { create(:ballot, year: year, user: user1, nbr_ratings: 25 ) }
    let!(:ballot2) { create(:ballot, year: year, user: user2, nbr_ratings: 50) }
    let!(:ballot3) { create(:ballot, year: year, user: user3, nbr_ratings: 25) }

    it "returns ballots by number of ratings and user's last name" do
      expect(Ballot.by_nbr_ratings(year)).to eq([ballot2, ballot3, ballot1])
    end

    it "returns ballot by only user's last name" do
      expect(Ballot.by_user_name(year)).to eq([ballot3, ballot1, ballot2])
    end
  end

  describe "ratings counter" do
    let!(:ballot) { create(:ballot) }
    let!(:ballot_with_no_ratings) { create(:ballot) }
    let!(:r1) { create(:rating, ballot: ballot) }
    let!(:r2) { create(:rating, ballot: ballot) }

    it "returns the total number of ratings" do
      expect(ballot.compute_total_nbr_ratings).to eq(2)
    end

    it "returns 0 for ballots with zero ratings" do
      expect(ballot_with_no_ratings.compute_total_nbr_ratings).to eq(0)
    end
  end

  describe "average ratings" do
    let!(:ballot) { create(:ballot)}
    let!(:ballot_with_no_ratings) { create(:ballot) }
    let!(:r1) { create(:rating, ballot: ballot, value: 2.0) }
    let!(:r2) { create(:rating, ballot: ballot, value: 2.5) }

    it "returns the average of all ratings" do
      expect(ballot.compute_average_rating).to eq(2.25)
    end

    it "returns nil for a ballot with zero ratings" do
      expect(ballot_with_no_ratings.compute_average_rating).to eq(nil)
    end
  end

  describe "specific rating value counter" do
    let!(:ballot) { create(:ballot)}
    let!(:ballot_with_no_ratings) { create(:ballot) }
    let!(:r1) { create(:rating, ballot: ballot, value: 2.0) }
    let!(:r2) { create(:rating, ballot: ballot, value: 2.5) }
    let!(:r3) { create(:rating, ballot: ballot, value: 2.5) }

    it "returns the number of ratings of a specific value" do
      expect(ballot.compute_nbr_ratings(2.5)).to eq(2)
    end

    it "returns zero when a ballot has no ratings of that value" do
      expect(ballot.compute_nbr_ratings(1.0)).to eq(0)
    end

    it "should handle ballots with zero ratings" do
      expect(ballot_with_no_ratings.compute_nbr_ratings(2.5)).to eq(0)
    end
  end

  describe "selectivity index computation" do
    let(:year) { create(:year) }
    let(:ballot) { create(:ballot, year: year) }
    let!(:m1) { create(:movie, average_rating: 4.00, year: year, nbr_ratings: 5) }
    let!(:m2) { create(:movie, average_rating: 3.50, year: year, nbr_ratings: 5) }
    let!(:m3) { create(:movie, average_rating: 3.00, year: year, nbr_ratings: 5) }
    let!(:m4) { create(:movie, average_rating: 2.50, year: year, nbr_ratings: 5) }
    let!(:r1) { create(:rating, movie: m1, ballot: ballot) }
    let!(:r2) { create(:rating, movie: m2, ballot: ballot) }
    let!(:r3) { create(:rating, movie: m3, ballot: ballot) }

    it "returns the correct selectivity index" do
      expect(ballot.compute_selectivity_index).to eq(100)
    end
  end
end
