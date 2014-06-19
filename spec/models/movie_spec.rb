require 'rails_helper'

describe Movie do

  it "has a valid factory" do
    expect(build(:movie)).to be_valid
  end

  it { should validate_presence_of :title }
  it { should validate_presence_of :year }
  it { should validate_presence_of :title_index }

  describe "results listing for category results" do
    let!(:year) { create(:year) }
    let!(:picture_category) { create(:category, name: "picture") }
    let!(:director_category) { create(:category, name: "director") }
    let!(:screenplay_category) { create(:category, name: "screenplay") }
    let!(:m1) { create(:movie, title: "abc", picture_points: 100, picture_votes: 15,
                               director_points: 150, director_votes: 10,
                               screenplay_points: 50, screenplay_votes: 5, year: year ) }
    let!(:m2) { create(:movie, title: "stu", picture_points: 150, picture_votes: 15,
                               director_points: 50, director_votes: 10,
                               screenplay_points: 100, screenplay_votes: 5, year: year ) }
    let!(:m3) { create(:movie, title: "zyx", picture_points: 100, picture_votes: 14,
                               director_points: 0, director_votes: 0,
                               screenplay_points: 50, screenplay_votes: 5, year: year ) }

    it "returns movies in best picture order and handles point ties" do
      expect(Movie.results_list(year, picture_category)).to eq([m2,m1,m3])
    end

    it "returns movies in best director order and handle movies with zero votes" do
      expect(Movie.results_list(year, director_category)).to eq([m1,m2])
    end

    it "returns movies in best screenplay order and handles point/vote ties" do
      expect(Movie.results_list(year, picture_category)).to eq([m2,m1,m3])
    end
  end

  describe "results listing for ratings results" do
    let!(:year) { create(:year) }
    let!(:m1) { create(:movie, title: "xyz", year: year, average_rating: 2.50, nbr_ratings: 5) }
    let!(:m2) { create(:movie, title: "stu", year: year, average_rating: 2.75, nbr_ratings: 5) }
    let!(:m3) { create(:movie, title: "abc", year: year, average_rating: 2.50, nbr_ratings: 5) }
    let!(:m4_too_few_ratings) { create(:movie, title: "ttt", year: year, average_rating: 3.00, nbr_ratings: 4) }

    it "returns movies in order by average rating and title" do
      expect(Movie.ratings_results_list(year)).to eq([m2,m3,m1])
    end
  end

  describe "list of movies with less than five but more than zero ratings for supplementary ratings page" do
    let!(:year) { create(:year) }
    let!(:m1) { create(:movie, title: "xyz", year: year, nbr_ratings: 5) }
    let!(:m2) { create(:movie, title: "stu", year: year, nbr_ratings: 4) }
    let!(:m3) { create(:movie, title: "The abc", year: year, nbr_ratings: 4) }
    let!(:m4) { create(:movie, title: "ttt", year: year, nbr_ratings: 0) }

    it "returns movies with less than five votes by title" do
      expect(Movie.less_than_five_ratings(year)).to eq([m3,m2])
    end
  end

  describe "list of movies with zero ratings for supplementary ratings page" do
    let!(:year) { create(:year) }
    let!(:m1) { create(:movie, title: "xyz", year: year, nbr_ratings: 1) }
    let!(:m2) { create(:movie, title: "stu", year: year, nbr_ratings: 0) }
    let!(:m3) { create(:movie, title: "The abc", year: year, nbr_ratings: 0) }

    it "returns movies with less than five votes by title" do
      expect(Movie.zero_ratings(year)).to eq([m3,m2])
    end
  end

  describe "ratings movie list display format" do
    let!(:year) { create(:year) }
    let!(:m1) { create(:movie, title: "xyz", year: year, nbr_ratings: 10) }
    let!(:m2) { create(:movie, title: "stu", year: year, nbr_ratings: 5) }

    it "returns title of movie with 10 or more ratings normally" do
      expect(m1.ratings_results_display_format).to eq(m1.title)
    end

    it "returns title of movie with less than 10 ratings in parenthesis" do
      expect(m2.ratings_results_display_format).to eq("(" + m2.title + ")")
    end
  end

  describe "determining points and number of votes in a given category" do
    let!(:screenplay_category) { create(:category, name: "screenplay")}
    let!(:picture_category) { create(:category, name: "picture") }
    let!(:director_category) { create(:category, name: "director") }
    let!(:m1) { create(:movie, director_points: 20, director_votes: 3,
       screenplay_points: 15, screenplay_votes: 2, picture_points: 5, picture_votes: 1)}

    it "returns points in a given category" do
      expect(m1.points_in_category(screenplay_category)).to eq(15)
      expect(m1.points_in_category(picture_category)).to eq(5)
      expect(m1.points_in_category(director_category)).to eq(20)
    end

    it "returns number of votes in a given category" do
      expect(m1.nbr_votes_in_category(screenplay_category)).to eq(2)
      expect(m1.nbr_votes_in_category(picture_category)).to eq(1)
      expect(m1.nbr_votes_in_category(director_category)).to eq(3)
    end
  end

  describe "computing title_index" do
    let(:the_past) { create(:movie, title: "The Past") }
    let(:a_separation) { create(:movie, title: "A Separation") }
    let(:an_education) { create(:movie, title: "An Education") }
    let(:upstream_color) { create(:movie, title: "Upstream Color") }

    it "moves an initial 'The'" do
      expect(the_past.title_index).to eq("Past, The")
    end

    it "moves an initial 'A'" do
      expect(a_separation.title_index).to eq("Separation, A")
    end

    it "moves an initial 'An'" do
      expect(an_education.title_index).to eq("Education, An")
    end

    it "duplicates title when title doesn't begin with an article" do
      expect(upstream_color.title_index).to eq("Upstream Color")
    end
  end

  describe "number of votes and total points computation in a given category" do
    let(:movie_with_votes) { create(:movie, title: "Movie 1") }
    let(:movie_without_votes) { create(:movie, title: "Movie 2")}
    let!(:picture_category) { create(:category, name: "Picture") }
    let!(:director_category) { create(:category, name: "Director") }
    let!(:v1) { create(:vote, movie: movie_with_votes, credit: nil, category: picture_category, points: 10) }
    let!(:v2) { create(:vote, movie: movie_with_votes, credit: nil, category: picture_category, points: 5) }
    let!(:v3) { create(:vote, movie: movie_with_votes, credit: nil, category: director_category, points: 5) }

    context "there are votes in the category" do
      it "returns the total points in a category" do
        expect(movie_with_votes.compute_points(picture_category)).to eq(15)
      end

      it "returns the number of votes in a category" do
        expect(movie_with_votes.compute_votes(picture_category)).to eq(2)
      end
    end

    context "there are no votes in the category" do
      it "returns 0" do
        expect(movie_without_votes.compute_points(director_category)).to eq(0)
      end

      it "returns 0" do
        expect(movie_without_votes.compute_votes(director_category)).to eq(0)
      end
    end
  end

  describe "total number of ratings computation" do
    let!(:movie) { create(:movie) }
    let!(:movie_with_no_ratings) { create(:movie) }
    let!(:r1) { create(:rating, movie: movie) }
    let!(:r2) { create(:rating, movie: movie) }

    context "movie has ratings" do
      it "returns the number of ratings" do
        expect(movie.compute_total_nbr_ratings).to eq(2)
      end
    end

    context "movie has no ratings" do
      it "returns 0" do
        expect(movie_with_no_ratings.compute_total_nbr_ratings).to eq(0)
      end
    end
  end

  describe "average rating computation" do
    let!(:movie) { create(:movie, title: "Movie 1")}
    let!(:movie_with_no_ratings) { create(:movie, title: "Movie with no ratings")}
    let!(:r1) { create(:rating, movie: movie, value: 2.0)}
    let!(:r2) { create(:rating, movie: movie, value: 2.5)}

    context "movie has ratings" do
      it "returns the correct average rating" do
        expect(movie.compute_average_rating).to eq(2.25)
      end
    end

    context "movie has no ratings" do
      it "returns 0" do
        expect(movie_with_no_ratings.compute_average_rating).to eq(nil)
      end
    end
  end

  describe "computation of number of ratings for a particular rating value" do
    let!(:movie) { create(:movie, title: "Movie 1:")}
    let!(:movie_with_no_ratings) { create(:movie, title: "Movie 2")}
    let!(:r1) { create(:rating, movie: movie, value: 2.0)}
    let!(:r2) { create(:rating, movie: movie, value: 2.5)}
    let!(:r3) { create(:rating, movie: movie, value: 2.5)}

    context "movie has ratings of the given value" do
      it "returns the total number of ratings" do
        expect(movie.compute_nbr_ratings(2.5)).to eq(2)
      end
    end

    context "movie has no ratings of the given value" do
      it "returns 0" do
        expect(movie_with_no_ratings.compute_nbr_ratings(2.5)).to eq(0)
      end
    end
  end

  describe "compute_standard_dev" do
    let!(:movie) { create(:movie, title: "Movie 1:")}
    let!(:movie_with_no_ratings) { create(:movie, title: "Movie 2")}
    let!(:r1) { create(:rating, movie: movie, value: 2.0)}
    let!(:r2) { create(:rating, movie: movie, value: 2.5)}
    let!(:r3) { create(:rating, movie: movie, value: 2.5)}

    context "movie has ratings" do
      it "returns the correct standard dev" do
        expect(movie.compute_standard_dev).to eq(0.24)
      end
    end

    context "movie has no ratings" do
      it "returns 0" do
        expect(movie_with_no_ratings.standard_dev).to eq(nil)
      end
    end
  end

  describe "director name determination" do
    let!(:movie) { create(:movie) }
    let!(:movie_with_director_display_value) { create(:movie, director_display: "Jean-Pierre and Luc Dardenne") }
    let!(:director_job) { create(:job, name: "director") }
    let!(:wes_anderson) { create(:person, first_name: "Wes", last_name: "Anderson") }
    let!(:jean_pierre_dardennes) { create(:person, first_name: "Jean-Pierre", last_name: "Dardennes") }
    let!(:c1) { create(:credit, movie: movie, job: director_job, person: wes_anderson) }
    let!(:c2) { create(:credit, movie: movie_with_director_display_value, job: director_job, person: wes_anderson) }

    context "movie has one director" do
      it "returns the director name determined from the movies credits" do
        expect(movie.director_name).to eq("Wes Anderson")
      end
    end

    context "movie has a director display value" do
      it "returns the director display value" do
        expect(movie_with_director_display_value.director_name).to eq("Jean-Pierre and Luc Dardenne")
      end
    end
  end

  describe "screenwriter name determination" do
    let!(:movie) { create(:movie) }
    let!(:movie_with_screenwriter_display_value) { create(:movie, screenwriter_display: "Jean-Pierre and Luc Dardenne") }
    let!(:screenwriter_job) { create(:job, name: "screenwriter") }
    let!(:wes_anderson) { create(:person, first_name: "Wes", last_name: "Anderson") }
    let!(:jean_pierre_dardennes) { create(:person, first_name: "Jean-Pierre", last_name: "Dardennes") }
    let!(:c1) { create(:credit, movie: movie, job: screenwriter_job, person: wes_anderson) }
    let!(:c2) { create(:credit, movie: movie_with_screenwriter_display_value, job: screenwriter_job, person: wes_anderson) }

    context "movie has one screenwriter" do
      it "returns the screenwriter name determined from the movie's credits" do
        expect(movie.screenwriter_name).to eq("Wes Anderson")
      end
    end

    context "movie has a screenwriter display value" do
      it "returns the screenwriter display value" do
        expect(movie_with_screenwriter_display_value.screenwriter_name).to eq("Jean-Pierre and Luc Dardenne")
      end
    end
  end
end
