require 'rails_helper'

describe "Ballot results pages spec" do

  describe "ballot results pages" do
    let!(:year) { create(:year) }
    let!(:u1) { create(:user, first_name: "Joe", last_name: "Schmoe") }
    let!(:u2) { create(:user, first_name: "Jane", last_name: "Doe") }
    let!(:b1) { create(:ballot, user: u1, year: year, nbr_ratings: 60, average_rating: 2.50, selectivity_index: 68) }
    let!(:b2) { create(:ballot, user: u2, year: year, nbr_ratings: 70, average_rating: 2.45, selectivity_index: 65) }

    before { visit results_ballots_path(year: year.name) }

    it "has ballot results" do
      expect(page).to have_content(u1.name)
      expect(page).to have_content(u2.name)
      expect(page).to have_content(b1.nbr_ratings)
      expect(page).to have_content(b1.average_rating)
      expect(page).to have_content(b1.selectivity_index)
      expect(page).to have_content(b2.nbr_ratings)
      expect(page).to have_content(b2.average_rating)
      expect(page).to have_content(b2.selectivity_index)
    end
  end
end
