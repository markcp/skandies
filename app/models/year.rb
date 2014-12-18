class Year < ActiveRecord::Base
  has_many :movies
  has_many :ballots
  has_many :credits
  has_many :scenes

  validates :name, presence: true
  validates :open_voting, presence: true
  validates :close_voting, presence: true
  validates :display_results, presence: true


  def self.results_display
    where("display_results < ?", Time.zone.now).last
  end

  def self.active_voting
    where("open_voting < ? AND close_voting > ?", Time.zone.now, Time.zone.now).last
  end

  def self.all_but_results_display
    year_array = []
    where("display_results < ?", Time.zone.now).all.each do |y|
      if y != Year.results_display
        year_array << y
      end
    end
    year_array
  end

  def self.get_display_year(year)
    if year
      where("name = ? and display_results < ?", year, Time.zone.now ).last
    else
      Year.results_display
    end
  end

  def eligible_movies_by_average_rating
    movies.where("nbr_ratings > 4").order(average_rating: :desc, title_index: :asc)
  end

  def ranked_movies_hash
    ranked_movies_hash = {}
    hold_for_ties_array = []
    tie_start_index = 0
    tie_average_rating = 0.00
    movies_array = eligible_movies_by_average_rating
    movies_array.each_with_index do |m,index|
      if m.average_rating == tie_average_rating || index == 0 # this movie is tied with the previous movie on the list
        hold_for_ties_array << m
        if index + 1 == movies_array.length # end of the list--move last movie (plus any previous ties) to hash
          rank_array = (tie_start_index..index + 1).to_a
          rank_sum = rank_array.inject(:+)
          average_rank_of_tied_movies = rank_sum.to_f / hold_for_ties_array.length.to_f
          hold_for_ties_array.each do |m|
            ranked_movies_hash[m.id] = average_rank_of_tied_movies
          end
        end
      else
        if hold_for_ties_array.length > 1 # there are two or more tied movies in the hold array
          rank_array = (tie_start_index..index).to_a
          rank_sum = rank_array.inject(:+)
          average_rank_of_tied_movies = rank_sum.to_f / hold_for_ties_array.length.to_f
          hold_for_ties_array.each do |m|
            ranked_movies_hash[m.id] = average_rank_of_tied_movies
          end
        elsif hold_for_ties_array.length == 1 # there is a single movie in the hold array.  There were no ties.
          ranked_movies_hash[hold_for_ties_array[0].id] = index
        end
        if index + 1 == movies_array.length # end of the list--move last movie to the hash
          ranked_movies_hash[m.id] = index + 1
        else
          hold_for_ties_array = [m]
          tie_start_index = index + 1
          tie_average_rating = m.average_rating
        end
      end
    end
    ranked_movies_hash
  end

  def save_movie_vote_results
    picture_category = Category.where(name: "picture").first
    director_category = Category.where(name: "director").first
    screenplay_category = Category.where(name: "screenplay").first
    movies.each do |m|
      m.picture_points = m.compute_points(picture_category)
      m.picture_votes = m.compute_votes(picture_category)
      m.director_points = m.compute_points(director_category)
      m.director_votes = m.compute_votes(director_category)
      m.screenplay_points = m.compute_points(screenplay_category)
      m.screenplay_votes = m.compute_votes(screenplay_category)
      m.save
    end
  end

  def save_credit_vote_results
    actor_job = Job.where(name: "Actor")
    credits.where(job: actor_job).each do |c|
      results_category = c.compute_results_category
      c.category = results_category
      c.points = c.compute_points_results(results_category)
      c.nbr_votes = c.compute_votes_results(results_category)
      c.save
    end
  end

  def save_scene_vote_results
    scenes.each do |s|
      s.nbr_votes = s.compute_votes
      s.points = s.compute_points
      s.save
    end
  end

  def save_ratings_results
    movies.each do |m|
      m.nbr_ratings = m.compute_total_nbr_ratings
      m.average_rating = m.compute_average_rating
      m.four_ratings = m.compute_nbr_ratings(4.0)
      m.three_pt_five_ratings = m.compute_nbr_ratings(3.5)
      m.three_ratings = m.compute_nbr_ratings(3.0)
      m.two_pt_five_ratings = m.compute_nbr_ratings(2.5)
      m.two_ratings = m.compute_nbr_ratings(2.0)
      m.one_pt_five_ratings = m.compute_nbr_ratings(1.5)
      m.one_ratings = m.compute_nbr_ratings(1.0)
      m.zero_ratings = m.compute_nbr_ratings(0.0)
      if m.compute_total_nbr_ratings > 1
        m.standard_dev = m.compute_standard_dev
      end
      m.save
    end
  end

  def save_user_profile_results
    ballots.each do |b|
      b.nbr_ratings = b.compute_total_nbr_ratings
      b.average_rating = b.compute_average_rating
      b.four_ratings = b.compute_nbr_ratings(4.0)
      b.three_pt_five_ratings = b.compute_nbr_ratings(3.5)
      b.three_ratings = b.compute_nbr_ratings(3.0)
      b.two_pt_five_ratings = b.compute_nbr_ratings(2.5)
      b.two_ratings = b.compute_nbr_ratings(2.0)
      b.one_pt_five_ratings = b.compute_nbr_ratings(1.5)
      b.one_ratings = b.compute_nbr_ratings(1.0)
      b.zero_ratings = b.compute_nbr_ratings(0.0)
      b.selectivity_index = b.compute_selectivity_index
      b.save
    end
  end

  def save_complete_results
    save_movie_vote_results
    save_credit_vote_results
    save_scene_vote_results
    save_ratings_results
    save_user_profile_results
  end
end
