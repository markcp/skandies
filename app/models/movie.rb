class Movie < ActiveRecord::Base
  belongs_to :year
  has_many :credits
  has_many :votes
  has_many :ratings
  has_many :scenes

  validates :title, presence: true
  validates :year_id, presence: true
  validates :title_index, presence: true

  before_validation :compute_title_index

  def compute_title_index
    title_without_leading_article = title.gsub(/(The|A|An)\s/,"")
    if $1
      self.title_index = title_without_leading_article + ", " + $1
    else
      self.title_index = title
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
    if ratings.count > 0
      points = 0
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
    sum = values.inject(0){ |accum, i| accum + i }
    mean = sum / values.length.to_f
    sample_variance = values.inject(0){ |accum, i| accum + (i - mean) ** 2 } / (values.length - 1).to_f
    standard_dev = Math.sqrt(sample_variance).round(2)
  end
end
