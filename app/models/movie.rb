class Movie < ActiveRecord::Base
  include Skandies::Maths

  belongs_to :year
  has_many :credits
  has_many :votes
  has_many :ratings
  has_many :scenes

  validates :title, presence: true
  validates :year, presence: true
  validates :title_index, presence: true

  before_validation :compute_title_index

  scope :by_title, -> { order("title_index ASC") }

  def self.results_list(year, category)
    if category.name == "director"
      where("year_id = ? and director_points > 0",year.id).order(director_points: :desc, director_votes: :desc, title_index: :asc)
    elsif category.name == "screenplay"
      where("year_id = ? and screenplay_points > 0",year.id).order(screenplay_points: :desc, screenplay_votes: :desc, title_index: :asc)
    else # category is best picture
      where("year_id = ? and picture_points > 0",year.id).order(picture_points: :desc, picture_votes: :desc, title_index: :asc)
    end
  end

  def average_rating_display
    ar = average_rating.round(2).to_s
    if ar.length == 3
      ar = ar + "0"
    end
    ar
  end

  def self.ratings_results_list(year)
    where("year_id = ? and nbr_ratings > 4", year.id).order(average_rating: :desc, title_index: :asc)
  end

  def self.less_than_five_ratings(year)
    where("year_id = ? and nbr_ratings < 5 and nbr_ratings > 0",year.id).order(title_index: :asc)
  end

  def self.zero_ratings(year)
    where(year: year, nbr_ratings: 0).order(title_index: :asc)
  end

  def ratings_results_display_format
    if nbr_ratings < 10
      "(" + title + ")"
    else
      title
    end
  end

  def self.voted_for(year, category)
    movies_array = []
    Movie.by_title.where(year: year).each do |m|
      votes_in_category = m.votes.where(category: category).all
      if votes_in_category.length > 0
        movies_array << m
      end
    end
    movies_array
  end

  def points_in_category(category)
    if category.name == "director"
      director_points
    elsif category.name == "screenplay"
      screenplay_points
    else
      picture_points
    end
  end

  def nbr_votes_in_category(category)
    if category.name == "director"
      director_votes
    elsif category.name == "screenplay"
      screenplay_votes
    else
      picture_votes
    end
  end

  def director_name
    if director_display
      director_display
    else
      director_job = Job.where(name: "director").first
      credit = credits.where(job: director_job).first
      if credit
        credit.person.name
      end
    end
  end

  def screenwriter_name
    if screenwriter_display
      screenwriter_display
    else
      screenwriter_job = Job.where(name: "screenwriter").first
      credit = credits.where(job: screenwriter_job).first
      if credit
        credit.person.name
      end
    end
  end

  def compute_title_index
    if title
      title_without_leading_article = title.gsub(/(The|A|An)\s/,"")
      if $1
        self.title_index = title_without_leading_article + ", " + $1
      else
        self.title_index = title
      end
    end
  end

  def compute_points(category)
    points = 0
    self.votes.where( category: category ).each do |v|
      points = points + v.points
    end
    points
  end

  def compute_votes(category)
    self.votes.where( category: category ).count
  end

  def compute_total_nbr_ratings
    ratings.count
  end

  def compute_average_rating
    points = 0
    if ratings.count > 0
      ratings.each do |r|
        points = points + r.value
      end
      average = (points / ratings.count).round(4)
    end
  end

  def compute_nbr_ratings(value)
    nbr_ratings = ratings.where(value: value).count
    if nbr_ratings
      nbr_ratings
    else
      0
    end
  end

  def compute_standard_dev
    values = ratings.map { |r| r.value }
    Skandies::Maths.standard_deviation(values).round(2)
  end
end
