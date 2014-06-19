class Category < ActiveRecord::Base
  has_many :votes
  has_many :credits, foreign_key: 'results_category_id'

  validates :name, presence: true

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
