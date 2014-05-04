class Vote < ActiveRecord::Base

  belongs_to :ballot
  belongs_to :category
  belongs_to :credit
  belongs_to :movie

  validate :correct_voting_object
  validates :ballot_id, presence: true
  validates :category_id, presence: true
  validates :points, presence: true

  def correct_voting_object
    if !self.credit_id.blank? && self.movie_id.blank? && self.value.blank? # credit vote (acting)
      return true
    elsif self.credit_id.blank? && !self.movie_id.blank? && self.value.blank? # movie vote (picture, director or screenplay)
      return true
    elsif self.credit_id.blank? && !self.movie_id.blank? && !self.value.blank? # scene vote
      return true
    elsif self.credit_id.blank? && self.movie_id.blank? && self.value.blank?
      errors.add(:value, "Must have a voting object.")
    else
      errors.add(:value, "Incorrect voting object.")
    end
  end
end
