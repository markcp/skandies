class Ballot < ActiveRecord::Base
  belongs_to :user
  belongs_to :year
  has_many :votes
  has_many :ratings
  has_many :top_ten_entries
  accepts_nested_attributes_for :votes
  has_many :category_vote_groups
  has_one :ratings_group
  has_one :top_ten_list

  validates :user, presence: true
  validates :year, presence: true
  validates :complete, inclusion: [ true, false ]
  validate :zero_or_ten_category_votes

  def valid_for_submission?
    category_vote_groups.each do |cvg|
      if !cvg.valid_for_submission?
        return false
      end
    end
    if ratings_group.valid_for_submission? && top_ten_list.valid_for_submission?
      return true
    else
      return false
    end
  end

  def zero_or_ten_category_votes
    Category.all.each do |cat|
      cat_votes = votes.where(category: cat).all
      if cat_votes.length == 0 || cat_votes.length == 10
        return true
      else
        errors.add(:ballot, "You must have 10 votes in a category.")
      end
    end
  end

  def self.past_ballots_by_user(user, year)
    past_ballots = []
    where(user: user).order("year_id DESC").each do |ballot|
      if ballot.year != year
        past_ballots << ballot
      end
    end
    past_ballots
  end

  def self.by_nbr_ratings(year)
    joins(:user).where("year_id = ? and nbr_ratings > 0", year.id).order("nbr_ratings DESC, users.last_name ASC")
  end

  def self.by_user_name(year)
    joins(:user).where("year_id = ?", year.id).order("users.last_name ASC")
  end

  def movie_votes_by_points(category)
    votes.joins(:movie).where(category: category).order("points DESC, movies.title_index ASC")
  end

  def credit_votes_by_points(category)
    votes.joins(credit: :person).where(category: category).order("points DESC, people.last_name ASC")
  end

  def scene_votes_by_points
    votes.joins(:scene).where(category: Category.best_scene).order("points DESC, scenes.title ASC")
  end

  def votes_by_points(category)
    if category.name == "picture" || category.name == "director" || category.name == "screenplay"
      votes.joins(:movie).where(category: category).order("points DESC, movies.title_index ASC")
    elsif category.name == "scene"
      votes.joins(:scene).where(category: Category.best_scene).order("points DESC, scenes.title ASC")
    else
      votes.joins(credit: :person).where(category: category).order("points DESC, people.last_name ASC")
    end
  end

  def ratings_by_movie_title
    ratings.joins(:movie).order("movies.title_index ASC")
  end

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
