class Category < ActiveRecord::Base
  has_many :votes
  has_many :category_vote_groups
  has_many :credits, foreign_key: 'results_category_id'

  validates :name, presence: true

  def self.ballot_display_order
    categories = []
    categories << Category.best_picture
    categories << Category.best_supporting_actor
    categories << Category.best_director
    categories << Category.best_supporting_actress
    categories << Category.best_actress
    categories << Category.best_screenplay
    categories << Category.best_actor
    categories << Category.best_scene
    categories
  end

  def display_name
    "Best " + name.titleize
  end

  def self.best_picture
    where( name: "picture").last
  end

  def self.best_director
    where(name: "director").last
  end

  def self.best_actress
    where(name: "actress").last
  end

  def self.best_actor
    where(name: "actor").last
  end

  def self.best_supporting_actress
    where(name: "supporting actress").last
  end

  def self.best_supporting_actor
    where(name: "supporting actor").last
  end

  def self.best_screenplay
    where(name: "screenplay").last
  end

  def self.best_scene
    where(name: "scene").last
  end

  def complementary_category
    complementary_category = case name
      when "actress" then Category.where(name: "supporting actress").first
      when "supporting actress" then Category.where(name: "actress").first
      when "actor" then Category.where(name: "supporting actor").first
      when "supporting actor" then Category.where(name: "actor").first
      else nil
    end
  end

  def tiebreaker_category
    if name == "actress" || name == "actor"
      return self
    else
      return self.complementary_category
    end
  end
end
