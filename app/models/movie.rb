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

  def picture_results_display
    "#{title} #{picture_points}/#{picture_votes}"
  end

  def director_results_display
    "#{director_name}, #{title} #{director_points}/#{director_votes}"
  end

  def screenplay_results_display
    "#{screenwriter_name}, #{title} #{screenplay_points}/#{screenplay_votes}"
  end

  def director_name
    if director_display
      director_display
    else
      director_job = Job.where(name: "Director").first
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
      screenwriter_job = Job.where(name: "Screenwriter").first
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
      average = (points / ratings.count).round(2)
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
