class Scene < ActiveRecord::Base
  belongs_to :movie
  belongs_to :year
  has_many :votes

  validates :title, presence: true
  validates :movie_id, presence: true
  validates :year_id, presence: true
end
