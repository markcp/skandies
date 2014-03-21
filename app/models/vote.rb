class Vote < ActiveRecord::Base

  belongs_to :ballot
  belongs_to :category
  belongs_to :credit
  belongs_to :movie

  validates :ballot_id, presence: true
  validates :category_id, presence: true
  validates :credit_id, presence: true, if: "movie_id.nil?"
  validates :movie_id, presence: true, if: "credit_id.nil?"
  validates :points, presence: true
end
