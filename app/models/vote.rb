class Vote < ActiveRecord::Base

  belongs_to :ballot
  belongs_to :category
  belongs_to :credit
  belongs_to :movie
  belongs_to :scene

  validate :correct_voting_object
  validates :ballot_id, presence: true
  validates :category_id, presence: true
  validates :points, presence: true

  def correct_voting_object
    if !self.credit_id.blank? && self.movie_id.blank? && self.scene_id.blank? # credit vote (acting)
      return true
    elsif self.credit_id.blank? && !self.movie_id.blank? && self.scene_id.blank? # movie vote (picture, director or screenplay)
      return true
    elsif self.credit_id.blank? && self.movie_id.blank? && !self.scene_id.blank? # scene vote
      return true
    elsif self.credit_id.blank? && self.movie_id.blank? && self.scene_id.blank?
      errors.add(:value, "Must have a voting object.")
    else
      errors.add(:value, "Incorrect voting object.")
    end
  end
end
