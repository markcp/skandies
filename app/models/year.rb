class Year < ActiveRecord::Base
  has_many :movies
  has_many :ballots
  has_many :credits
  has_many :scenes

  validates :name, presence: true
  validates :open_voting, presence: true
  validates :close_voting, presence: true
  validates :display_results, presence: true

  def ranked_movies_hash
    ranked_movies_hash = {}
    hold_for_ties_array = []
    tie_start_index = 0
    tie_average_rating = 0.00
    movies_array = movies.where("nbr_ratings > 4").order(average_rating: :desc)
    movies_array.each_with_index do |m,index|
      if m.average_rating == tie_average_rating || index == 0 # this movie is tied with the previous movie on the list
        hold_for_ties_array << m
      else
        if hold_for_ties_array.length > 1 # there are two or more tied movies in the hold array
          rank_array = (tie_start_index..index).to_a
          rank_sum = 0
          rank_array.each do |n|
            rank_sum = rank_sum + n
          end
          average_rank_of_tied_movies = rank_sum.to_f / hold_for_ties_array.length.to_f
          hold_for_ties_array.each do |m|
            ranked_movies_hash[m.id] = average_rank_of_tied_movies
          end
        elsif hold_for_ties_array.length == 1 # there is a single movie in the hold array.  There were no ties.
          ranked_movies_hash[hold_for_ties_array[0].id] = index
        end
        hold_for_ties_array = [m]
        tie_start_index = index + 1
        tie_average_rating = m.average_rating
      end
    end
    ranked_movies_hash
  end

  def compute_voting_results
    picture_category = Category.where(name: "Picture").first
    director_category = Category.where(name: "Director").first
    screenplay_category = Category.where(name: "Screenplay").first
    movies.each do |m|
      m.picture_points = m.compute_points(picture_category)
      m.picture_votes = m.compute_votes(picture_category)
      m.director_points = m.compute_points(director_category)
      m.director_votes = m.compute_votes(director_category)
      m.screenplay_points = m.compute_points(screenplay_category)
      m.screenplay_votes = m.compute_votes(screenplay_category)
      m.save
    end

    actor_job = Job.where(name: "Actor")
    credits.where(job: actor_job).each do |c|
      results_category = c.compute_results_category
      c.category = results_category
      c.points = c.compute_points_results(results_category)
      c.nbr_votes = c.compute_votes_results(results_category)
      c.save
    end

    scenes.each do |s|
      s.nbr_votes = s.compute_votes
      s.points = s.compute_points
      s.save
    end

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
      m.save
    end

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
end
