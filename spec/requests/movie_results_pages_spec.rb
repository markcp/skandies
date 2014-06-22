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

  describe "ratings results page" do
    let!(:year) { create(:year) }
    let!(:m1) { create(:movie, year: year, title: "Movie 1",
      nbr_ratings: 10, average_rating: 3.00, four_ratings: 0,
      three_pt_five_ratings: 1, three_ratings: 2, two_pt_five_ratings: 5,
      two_ratings: 2, one_pt_five_ratings: 1, one_ratings: 1, zero_ratings: 0, standard_dev: 0.30) }
    let!(:m2) { create(:movie, year: year, title: "Movie 2",
      nbr_ratings: 5, average_rating: 2.80, four_ratings: 0,
      three_pt_five_ratings: 1, three_ratings: 1, two_pt_five_ratings: 5,
      two_ratings: 1, one_pt_five_ratings: 2, one_ratings: 0, zero_ratings: 0, standard_dev: 0.33) }
    let!(:movie_with_too_few_ratings) { create(:movie, year: year, title: "Movie 3", nbr_ratings: 4, average_rating: 2.00) }

    before { visit results_movies_path(year: year.name) }

    it "has movie rating results" do
      expect(page).to have_content(m1.title)
      expect(page).to have_content("(" + m2.title + ")")
      expect(page).to_not have_content(movie_with_too_few_ratings.title)
      expect(page).to have_content(m1.average_rating)
      expect(page).to have_content(m1.standard_dev)
      expect(page).to have_content(m2.average_rating)
      expect(page).to have_content(m2.standard_dev)
    end
  end

  describe "supplementary ratings page" do
    let!(:year) { create(:year) }
    let!(:m1) { create(:movie, year: year, title: "Movie 1",
      nbr_ratings: 4) }
    let!(:m2) { create(:movie, year: year, title: "Movie 2",
      nbr_ratings: 0) }
    let!(:movie_with_too_many_ratings) { create(:movie, year: year, title: "Movie 3",
      nbr_ratings: 5) }
    let!(:b1) { create(:ballot, year: year) }
    let!(:r1) { create(:rating, movie: m1, value: 2.5, ballot: b1 ) }

    before { visit supplementary_ratings_results_movies_path(year: year.name) }

    it "has a list of movies with fewer than 5 votes" do
      expect(page).to have_content("Supplementary Ratings")
      expect(page).to have_content(m1.title)
      expect(page).to have_content(m2.title)
      expect(page).to_not have_content(movie_with_too_many_ratings.title)
      expect(page).to have_content(r1.ballot.user.last_name)
    end
  end
end
