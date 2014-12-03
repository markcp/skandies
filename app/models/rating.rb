class Rating < ActiveRecord::Base
  belongs_to :movie
  belongs_to :ballot

  validates :movie, presence: true
  validates :ballot, presence: true
  validates :value, presence: true, inclusion: { in: [0.0, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0] }
end
