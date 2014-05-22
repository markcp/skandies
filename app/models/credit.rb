class Credit < ActiveRecord::Base
  belongs_to :movie
  belongs_to :person
  belongs_to :job
  belongs_to :year
  belongs_to :category, foreign_key: 'results_category_id'
  has_many :votes

  validates :person_id, presence: true
  validates :movie_id, presence: true
  validates :job_id, presence: true
  validates :year_id, presence: true
end

