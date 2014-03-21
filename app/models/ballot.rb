class Ballot < ActiveRecord::Base
  belongs_to :user
  belongs_to :year
  has_many :votes

  validates :user_id, presence: true
  validates :year, presence: true
  validates :complete, inclusion: [ true, false ]
end
