class Year < ActiveRecord::Base
  has_many :movies
  has_many :ballots
  has_many :credits
  has_many :scenes

  validates :name, presence: true
  validates :open_voting, presence: true
  validates :close_voting, presence: true
  validates :display_results, presence: true
end
