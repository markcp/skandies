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
    picture_points = 0
    self.votes.where( category: category ).each do |v|
      picture_points = picture_points + v.points
    end
    picture_points
  end

  def compute_votes(category)
    category = Category.where( name: "Picture" ).first
    picture_votes = self.votes.where( category: category ).count
  end
end
