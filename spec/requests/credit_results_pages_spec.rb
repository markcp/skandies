require 'rails_helper'

describe "Credit results pages" do

  describe "Credit result" do
    let!(:movie) { create(:movie) }
    let!(:category) { create(:category, name: "actress") }
    let!(:p1) { create(:person, last_name: "Foo", first_name: "Bar") }
    let!(:c1) { create(:credit, person: p1, movie: movie, category: category) }
    let!(:u1) { create(:user, first_name: "Jim", last_name: "Jam") }
    let!(:u2) { create(:user, first_name: "James", last_name: "Smith") }
    let!(:b1) { create(:ballot, user: u1) }
    let!(:b2) { create(:ballot, user: u2) }
    let!(:v1) { create(:vote, category: category, credit: c1, ballot: b1, points: 30) }
    let!(:v2) { create(:vote, category: category, credit: c1, ballot: b2, points: 20) }

    before { visit results_credit_path(c1) }

    it "has credit votes" do
      expect(page).to have_content("Best Actress")
      expect(page).to have_content(p1.name)
      expect(page).to have_content(movie.title)
      expect(page).to have_content(u1.name)
      expect(page).to have_content(v1.points)
      expect(page).to have_content(u2.name)
      expect(page).to have_content(v2.points)
    end
  end

end
