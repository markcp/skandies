class Scene < ActiveRecord::Base
  belongs_to :movie
  has_many :votes

  validates :title, presence: true
  validates :movie_id, presence: true
end
