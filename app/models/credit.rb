class Credit < ActiveRecord::Base
  belongs_to :movie
  belongs_to :person
  belongs_to :job

  validates :person_id, presence: true
  validates :movie_id, presence: true
  validates :job_id, presence: true
end
