class Movie < ActiveRecord::Base
  validates :title, presence: true
  validates :year, presence: true, numericality: {
    greater_than: 1994 , less_than: 2050
  }
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
