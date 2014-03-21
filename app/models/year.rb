class Year < ActiveRecord::Base
  has_many :movies
  has_many :ballots

  validates :name, presence: true
  validates :open_voting, presence: true
  validates :close_voting, presence: true
  validates :display_results, presence: true
end
