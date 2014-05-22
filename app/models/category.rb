class Category < ActiveRecord::Base
  has_many :votes
  has_many :credits, foreign_key: 'results_category_id'

  validates :name, presence: true
end
