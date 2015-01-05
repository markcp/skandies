class Rating < ActiveRecord::Base
  belongs_to :movie
  belongs_to :ballot
  belongs_to :ratings_group

  validates :movie, presence: true
  validates :ballot, presence: true
  validates :value, presence: true, inclusion: { in: [0.0, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0] }

  default_scope { includes(:movie).order("movies.title_index ASC") }

end
