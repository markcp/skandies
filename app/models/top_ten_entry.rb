class TopTenEntry < ActiveRecord::Base
  belongs_to :ballot
  belongs_to :top_ten_list

  validates :ballot, presence: true
  validates :value, presence: true
  validates :rank, numericality: true, inclusion: { in: 0..10, message: "must be a number between 0 and 10" }

  default_scope { order('rank ASC, id ASC') }

  def self.by_rank
    order(rank: :asc)
  end
end

