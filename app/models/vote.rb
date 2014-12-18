class Vote < ActiveRecord::Base

  belongs_to :ballot
  belongs_to :category
  belongs_to :credit
  belongs_to :movie
  belongs_to :scene

  validate :correct_voting_object
  validates :ballot, presence: true
  validates :category, presence: true
  validates :points, presence: true

  def object_display
    if category == Category.best_picture
      movie.title
    elsif category == Category.best_director
      movie.director_name
    elsif category == Category.best_screenplay
      movie.screenwriter_name
    elsif category == Category.best_scene
      scene.title
    else # acting categories
      credit.person.name
    end
  end

  def movie_display
    if category == Category.best_picture
      nil
    elsif category == Category.best_director || category == Category.best_director || category == Category.best_screenplay
      movie.title
    elsif category == Category.best_scene
      scene.movie.title
    else #acting categories
      credit.movie.title
    end
  end

  def self.by_points_and_user_name
    joins(ballot: :user).order("points DESC, users.last_name ASC")
  end

  def self.by_category_and_points_and_user_name(category)
    joins(ballot: :user).where( category: category).order("points DESC, users.last_name ASC")
  end

  def correct_voting_object
    if !self.credit_id.blank? && self.movie_id.blank? && self.scene_id.blank? # credit vote (acting)
      return true
    elsif self.credit_id.blank? && !self.movie_id.blank? && self.scene_id.blank? # movie vote (picture, director or screenplay)
      return true
    elsif self.credit_id.blank? && self.movie_id.blank? && !self.scene_id.blank? # scene vote
      return true
    elsif self.credit_id.blank? && self.movie_id.blank? && self.scene_id.blank?
      errors.add(:credit_id, "Must have a voting object.")
    else
      errors.add(:credit_id, "Incorrect voting object.")
    end
  end
end
