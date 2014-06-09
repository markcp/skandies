class Rating < ActiveRecord::Base
  belongs_to :movie
  belongs_to :ballot

  validates :movie, presence: true
  validates :ballot, presence: true
  validates :value, presence: true
end
