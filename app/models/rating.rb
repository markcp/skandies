class Rating < ActiveRecord::Base
  belongs_to :movie
  belongs_to :ballot

  validates :movie_id, presence: true
  validates :ballot_id, presence: true
  validates :value, presence: true
end
