class Credit < ActiveRecord::Base
  belongs_to :movie
  belongs_to :person
  belongs_to :job
  has_many :votes

  validates :person_id, presence: true
  validates :movie_id, presence: true
  validates :job_id, presence: true
end
