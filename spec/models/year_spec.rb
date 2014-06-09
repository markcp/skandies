require 'rails_helper'

describe Year do

  it "has a valid factory" do
    expect(build(:year)).to be_valid
  end

  it {should validate_presence_of :name }
  it {should validate_presence_of :open_voting }
  it {should validate_presence_of :close_voting }
  it {should validate_presence_of :display_results }

  describe "default values for datetime fields" do
    let!(:year) { create(:year) }

    it "has a default value in open_voting" do
      expect(year.open_voting).to eq("2001-01-01 00:00:00")
    end

    it "has a default value in close_voting" do
      expect(year.close_voting).to eq("2001-01-01 00:00:00")
    end

    it "has a default value in display_results" do
      expect(year.display_results).to eq("2001-01-01 00:00:00")
    end
  end

  describe "list eligible movies by average rating" do
    let!(:year) { create(:year) }
    let!(:m1) { create(:movie, nbr_ratings: 4, year: year, average_rating: 4.00) }
    let!(:m2) { create(:movie, nbr_ratings: 5, year: year, average_rating: 4.00) }
    let!(:m3) { create(:movie, nbr_ratings: 6, year: year, average_rating: 1.00) }
    let!(:m4) { create(:movie, nbr_ratings: 10, year: year, average_rating: 3.00) }

    it "returns a list of movies with more than 4 votes in average rating order" do
      expect(year.eligible_movies_by_average_rating).to eq([m2, m4, m3])
    end
  end

  describe "create a hash of eligible movies and their rank, including an average rank value for ties" do
    let!(:year) { create(:year) }
    let!(:movie1) { create(:movie, year: year, nbr_ratings: 5, average_rating: 2.00) }
    let!(:movie2) { create(:movie, year: year, nbr_ratings: 5, average_rating: 3.00) }
    let!(:movie3) { create(:movie, year: year, nbr_ratings: 5, average_rating: 1.00) }
    let!(:movie4) { create(:movie, year: year, nbr_ratings: 5, average_rating: 1.00) }
    let!(:movie5) { create(:movie, year: year, nbr_ratings: 5, average_rating: 2.00) }
    let!(:movie_with_too_few_votes) { create(:movie, year: year, nbr_ratings: 4, average_rating: 2.00) }

    it "should rank movies correctly" do
      expect(year.ranked_movies_hash[movie2.id]).to eq(1)
    end

    it "should handle tied movies" do
      expect(year.ranked_movies_hash[movie1.id]).to eq(2.5)
      expect(year.ranked_movies_hash[movie5.id]).to eq(2.5)
    end

    it "should handle tied movies at the end of the list" do
      expect(year.ranked_movies_hash[movie4.id]).to eq(4.5)
      expect(year.ranked_movies_hash[movie3.id]).to eq(4.5)
    end

    it "should not rank movies with fewer than 5 votes" do
      expect(year.ranked_movies_hash[movie_with_too_few_votes.id]).to eq(nil)
    end
  end

  # describe "save best picture, director, and screenplay voting results on movie records" do
  #   let!(:year) { create(:year) }
  #   let!(:picture_category) { create(:category, name: "Picture") }
  #   let!(:director_category) { create(:category, name: "Director") }
  #   let!(:screenplay_category) { create(:category, name: "Screenplay") }
  #   let!(:movie) { create(:movie, year: year) }
  #   let!(:v1) { create(:vote, movie: movie, credit_id: nil, category: picture_category, points: 10) }
  #   let!(:v2) { create(:vote, movie: movie, credit_id: nil, category: director_category, points: 5) }
  #   let!(:v3) { create(:vote, movie: movie, credit_id: nil, category: screenplay_category, points: 15) }

  #   before { year.save_movie_vote_results }

  #   it "should save correct best picture point value to movie record" do
  #     puts movie.picture_points
  #     puts year.save_movie_vote_results.to_s
  #     movie.save
  #     puts movie.picture_points
  #     expect(movie.picture_points).to eq(10)
  #     expect(movie.picture_votes).to eq(1)
  #   end

  #   it "should save correct best director point value to movie record" do
  #     puts movie.director_points
  #     puts year.save_movie_vote_results.to_s
  #     expect(movie.director_points).to eq(5)
  #     expect(movie.director_votes).to eq(1)
  #   end
  # end

  # describe "save best performances voting results on credit records" do
  #   let!(:year) { create(:year) }
  #   let!(:credit) { create(:credit, year: year) }
  #   let!(:v1) { create(:vote, points: 10) }

  #   before { year.save_movie_vote_results }

  #   it "should save correct best picture point value to movie record" do
  #     puts credit.compute_results_category
  #     expect(credit.points).to eq(10)
  #     expect(credit.nbr_votes).to eq(1)
  #   end
  # end
end
