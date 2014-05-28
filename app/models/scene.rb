class Scene < ActiveRecord::Base
  belongs_to :movie
  belongs_to :year
  has_many :votes

  validates :title, presence: true
  validates :movie_id, presence: true
  validates :year_id, presence: true

  def compute_points
    scene_category = Category.where( name: "Scene" ).first
    points = 0
    self.votes.where(category: scene_category).each do |v|
      points = points + v.points
    end
    points
  end

  def compute_votes
    scene_category = Category.where( name: "Scene" ).first
    votes.where( category: scene_category ).count
  end
end
