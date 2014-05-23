class Year < ActiveRecord::Base
  has_many :movies
  has_many :ballots
  has_many :credits
  has_many :scenes

  validates :name, presence: true
  validates :open_voting, presence: true
  validates :close_voting, presence: true
  validates :display_results, presence: true

  def compute_voting_results
    picture_category = Category.where(name: "Picture").first
    director_category = Category.where(name: "Director").first
    screenplay_category = Category.where(name: "Screenplay").first
    movies.each do |m|
      m.picture_points = m.compute_points(picture_category)
      m.picture_votes = m.compute_votes(picture_category)
      m.director_points = m.compute_points(director_category)
      m.director_points = m.compute_points(director_category)
      m.screenplay_votes = m.compute_votes(screenplay_category)
      m.screenplay_votes = m.compute_votes(screenplay_category)
      m.save
    end
  end
end
