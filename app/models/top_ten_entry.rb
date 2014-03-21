class TopTenEntry < ActiveRecord::Base
  belongs_to :ballot

  validates :ballot_id, presence: true
  validates :value, presence: true
  validates :rank, inclusion: 0..10

end
