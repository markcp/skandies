class RatingsGroup < ActiveRecord::Base
  has_many :ratings#, -> { joins(:movie).order("movies.title_index") }
  belongs_to :ballot
  accepts_nested_attributes_for :ratings, reject_if: :reject_rating, allow_destroy: true

  validates :ballot_id, presence: true

  def reject_rating(attributes)
    exists = attributes['id'].present?
    empty = attributes[:value].blank?
    attributes.merge!({:_destroy => 1}) if exists and empty
    return (!exists and empty)
  end

  def valid_for_submission?
    ratings.length > 0
  end

end
