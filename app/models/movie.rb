class Movie < ActiveRecord::Base
  belongs_to :year
  has_many :credits
  has_many :votes

  validates :title, presence: true
  validates :year_id, presence: true
  validates :title_index, presence: true

  before_validation :compute_title_index

  def compute_title_index
    title_without_leading_article = title.gsub(/(The|A|An)\s/,"")
    if $1
      self.title_index = title_without_leading_article + ", " + $1
    else
      self.title_index = title
    end
  end

end
