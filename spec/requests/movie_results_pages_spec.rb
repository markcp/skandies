require 'rails_helper'

describe "Movie results pages" do

  describe "Movie result" do
    let!(:movie) { create(:movie) }
    let!(:category) { create(:category, name: "picture") }
    let!(:u1) { create(:user, first_name: "Jim", last_name: "Jam") }
    let!(:u2) { create(:user, first_name: "James", last_name: "Smith") }
    let!(:b1) { create(:ballot, user: u1) }
    let!(:b2) { create(:ballot, user: u2) }
    let!(:v1) { create(:vote, category: category, credit: nil, ballot: b1, movie: movie, points: 30) }
    let!(:v2) { create(:vote, category: category, credit: nil, ballot: b2, movie: movie, points: 20) }

    before { visit results_movie_path(movie, category: category.id) }

    it "has movie votes" do
      expect(page).to have_content("Best Picture")
      expect(page).to have_content(movie.title)
      expect(page).to have_content(u1.name)
      expect(page).to have_content(v1.points)
      expect(page).to have_content(u2.name)
      expect(page).to have_content(v2.points)
    end
  end
end
