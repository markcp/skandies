class Scene < ActiveRecord::Base
  belongs_to :movie
  belongs_to :year
  has_many :votes

  validates :title, presence: true
  validates :movie, presence: true
  validates :year, presence: true

  def self.results_list(year)
    where("year_id = ? and points > 0", year.id).order(points: :desc, nbr_votes: :desc, title: :asc)
  end

  def self.results_list_top_25(year)
    where("year_id = ? and points > 0", year.id).order(points: :desc, nbr_votes: :desc, title: :asc).limit(25)
  end

  def compute_points
    scene_category = Category.where( name: "scene" ).first
    points = 0
    self.votes.where(category: scene_category).each do |v|
      points = points + v.points
    end
    points
  end

  def compute_votes
    scene_category = Category.where( name: "scene" ).first
    votes.where( category: scene_category ).count
  end
end
