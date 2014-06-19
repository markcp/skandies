require 'rails_helper'

describe "Category results pages" do

  describe "voting results page - best picture" do
    let!(:year) { create(:year) }
    let!(:category) { create(:category, name: "picture") }
    let!(:m1) { create(:movie, year: year, title: "Movie 1", picture_points: 200, picture_votes: 30) }
    let!(:m2) { create(:movie, year: year, title: "Movie 2", picture_points: 250, picture_votes: 35) }
    let!(:movie_with_no_votes) { create(:movie, year: year, title: "Movie 4", picture_points: 0, picture_votes: 0) }

    before { visit results_category_path(category,year: year.name) }

    it "has best picture results" do
      expect(page).to have_content("Best Picture")
      expect(page).to have_content(year.name)
      expect(page).to have_content(m1.title)
      expect(page).to have_content(m1.picture_points.to_s + " / " + m1.picture_votes.to_s)
      expect(page).to have_content(m2.title)
      expect(page).to have_content(m2.picture_points.to_s + " / " + m2.picture_votes.to_s)
      expect(page).not_to have_content(movie_with_no_votes.title)
    end
  end

  describe "voting results page - best director" do
    let!(:year) { create(:year) }
    let!(:category) { create(:category, name: "director") }
    let!(:m1) { create(:movie, year: year, title: "Movie 1", director_points: 200, director_votes: 30) }
    let!(:m2) { create(:movie, year: year, title: "Movie 2", director_points: 250, director_votes: 35) }
    let!(:movie_with_no_votes) { create(:movie, year: year, title: "Movie 3", director_points: 0, director_votes: 0) }

    before { visit results_category_path(category, year: year.name) }

    it "has best director results" do
      expect(page).to have_content("Best Director")
      expect(page).to have_content(year.name)
      expect(page).to have_content(m1.title)
      expect(page).to have_content(m1.director_name)
      expect(page).to have_content(m1.director_points.to_s + " / " + m1.director_votes.to_s)
      expect(page).to have_content(m2.title)
      expect(page).to have_content(m2.director_name)
      expect(page).not_to have_content(movie_with_no_votes.title)
    end
  end

  describe "voting results pages for credits (acting)" do
    let!(:year) { create(:year) }
    let!(:category) { create(:category, name: "actress") }
    let!(:m1) { create(:movie, title: "Foo", year: year) }
    let!(:m2) { create(:movie, title: "Bar", year: year) }
    let!(:p1) { create(:person, first_name: "Moo", last_name: "Cow", gender: "F") }
    let!(:p2) { create(:person, first_name: "Wow", last_name: "Fow", gender: "F") }
    let!(:p3) { create(:person, first_name: "No", last_name: "Show") }
    let!(:c1) { create(:credit, movie: m1, results_category_id: category.id, person: p1, year: year, points: 200, nbr_votes: 30) }
    let!(:c2) { create(:credit, movie: m2, results_category_id: category.id, person: p2, year: year, points: 250, nbr_votes: 35) }
    let!(:credit_with_no_votes) { create(:credit, movie: m1, results_category_id: category.id, person: p3, year: year, points: 0, nbr_votes: 0) }

    before { visit results_category_path(category, year: year.name) }

    it "has best actress results" do
      expect(page).to have_content("Best Actress")
      expect(page).to have_content(year.name)
      expect(page).to have_content(m1.title)
      expect(page).to have_content(m1.title)
      expect(page).to have_content(p1.name)
      expect(page).to have_content(p2.name)
      expect(page).to have_content(c1.points.to_s + " / " + c1.nbr_votes.to_s)
      expect(page).to have_content(c2.points.to_s + " / " + c2.nbr_votes.to_s)
      expect(page).not_to have_content(credit_with_no_votes.person.name)
    end
  end

  describe "voting results page - best screenplay" do
    let!(:year) { create(:year) }
    let!(:category) { create(:category, name: "screenplay") }
    let!(:m1) { create(:movie, year: year, title: "Movie 1", screenplay_points: 200, screenplay_votes: 30) }
    let!(:m2) { create(:movie, year: year, title: "Movie 2", screenplay_points: 250, screenplay_votes: 35) }

    before { visit results_category_path(category, year: year.name) }

    it "has best screenplay results" do
      expect(page).to have_content("Best Screenplay")
      expect(page).to have_content(year.name)
      expect(page).to have_content(m1.title)
      expect(page).to have_content(m1.screenwriter_name)
      expect(page).to have_content(m1.screenplay_points.to_s + " / " + m1.screenplay_votes.to_s)
      expect(page).to have_content(m2.title)
      expect(page).to have_content(m2.screenwriter_name)
    end
  end

  describe "voting results page - best scene" do
    let!(:year) { create(:year) }
    let!(:category) { create(:category, name: "scene") }
    let!(:m1) { create(:movie, year: year, title: "Movie 1", screenplay_points: 200, screenplay_votes: 30) }
    let!(:m2) { create(:movie, year: year, title: "Movie 2", screenplay_points: 250, screenplay_votes: 35) }
    let!(:s1) { create(:scene, movie: m1, year: year, nbr_votes: 4, points: 30, title: "Scene 1")}
    let!(:s2) { create(:scene, movie: m2, year: year, nbr_votes: 5, points: 35, title: "Scene 2")}

    before { visit results_category_path(category, year: year.name) }

    it "has best screenplay results" do
      expect(page).to have_content("Best Scene")
      expect(page).to have_content(year.name)
      expect(page).to have_content(m1.title)
      expect(page).to have_content(s1.title)
      expect(page).to have_content(s1.points.to_s + " / " + s1.nbr_votes.to_s)
      expect(page).to have_content(m2.title)
      expect(page).to have_content(s2.title)
      expect(page).to have_content(s2.points.to_s + " / " + s2.nbr_votes.to_s)
    end
  end
end
