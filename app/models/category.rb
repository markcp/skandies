class Category < ActiveRecord::Base
  has_many :votes
  has_many :credits, foreign_key: 'results_category_id'

  validates :name, presence: true

  def complementary_category
    complementary_category = case name
      when "Actress" then Category.where(name: "Supporting Actress").first
      when "Supporting Actress" then Category.where(name: "Actress").first
      when "Actor" then Category.where(name: "Supporting Actor").first
      when "Supporting Actor" then Category.where(name: "Actor").first
      else nil
    end
  end

  def tiebreaker_category
    if name == "Actress" || name == "Actor"
      return self
    else
      return self.complementary_category
    end
  end
end
