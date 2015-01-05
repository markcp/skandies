class CategoryVoteGroup < ActiveRecord::Base
  has_many :votes
  belongs_to :category
  belongs_to :ballot
  accepts_nested_attributes_for :votes, reject_if: :reject_vote, allow_destroy: true

  validates :category_id, presence: true
  validates :ballot_id, presence: true

  def reject_vote(attributes)
    exists = attributes['id'].present?
    empty = attributes[:movie_id].blank? && attributes[:value].blank? && attributes[:points].blank?
    attributes.merge!({:_destroy => 1}) if exists and empty
    return (!exists and empty)
  end

  def vote_is_blank(attributed)
    attributed['value'].blank? && attributed['movie_id'].blank?
  end

  def valid_for_submission?
    votes.length == 10 && point_total == 100
  end

  def point_total
    point_total = 0
    votes.each do |v|
      point_total = point_total + v.points
    end
    point_total
  end

end
