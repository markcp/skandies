class Job < ActiveRecord::Base
  has_many :credits

  validates :name, presence: true
end
