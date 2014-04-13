class Person < ActiveRecord::Base
  has_many :credits

  validates :last_name, presence: true
  validates :gender, inclusion: [ 'M', 'F', 'O' ]
  validates :last_name_first, inclusion: [ true, false ]
end
