class Ballot < ActiveRecord::Base
  belongs_to :user
  belongs_to :year
  has_many :votes
  has_many :ratings
  has_many :top_ten_entries

  validates :user_id, presence: true
  validates :year, presence: true
  validates :complete, inclusion: [ true, false ]

  def compute_total_nbr_ratings
    ratings.count
  end

  def compute_average_rating
    if ratings.length > 0
      points = 0
      ratings.each do |r|
        points = points + r.value
      end
      average = points / ratings.count
      average.round(2)
    end
  end

  def compute_nbr_ratings(value)
    ratings.where(value: value).count
  end

  def compute_selectivity_index
    if ratings.length > 0
      ranked_movies_hash = year.ranked_movies_hash
      total_nbr_movies = ranked_movies_hash.size
      total_points = 0
      nbr_ranked_movies_seen = 0
      ratings.each do |r|
        if ranked_movies_hash[r.movie.id]
          nbr_ranked_movies_seen = nbr_ranked_movies_seen + 1
          total_points = total_points + ranked_movies_hash[r.movie.id]
        end
      end
      numerator = total_nbr_movies.to_f - (nbr_ranked_movies_seen.to_f - 1) / 2 - total_points.to_f/nbr_ranked_movies_seen.to_f
      denominator = total_nbr_movies.to_f - nbr_ranked_movies_seen.to_f
      selectivity_index = (numerator / denominator * 100).round(0)
      selectivity_index
    end
  end
end
