class Credit < ActiveRecord::Base
  belongs_to :movie
  belongs_to :person
  belongs_to :job
  belongs_to :year
  belongs_to :category, foreign_key: 'results_category_id'
  has_many :votes

  validates :person, presence: true
  validates :movie, presence: true
  validates :job, presence: true
  validates :year, presence: true

  def results_display
    "#{person.name}, #{movie.title} #{points}/#{nbr_votes}"
  end

  def points_by_category(category)
    total_points = 0
    votes.where(category: category).each do |v|
      total_points = total_points + v.points
    end
    total_points
  end

  def number_of_votes(category)
    votes.where(category: category).count
  end

  def compute_points_results(results_category)
    points_by_category(results_category) + points_by_category(results_category.complementary_category)
  end

  def compute_votes_results(results_category)
    number_of_votes(results_category) + number_of_votes(results_category.complementary_category)
  end

  def compute_results_category
    # todo: handle what happens if votes are in non-compatable categories
    first_category = votes.first.category
    complementary_category = first_category.complementary_category
    nbr_votes_in_first_category = number_of_votes(first_category)
    nbr_votes_in_complementary_category = number_of_votes(complementary_category)
    if nbr_votes_in_first_category > nbr_votes_in_complementary_category
      return first_category
    elsif nbr_votes_in_complementary_category > nbr_votes_in_first_category
      return complementary_category
    else # both categories have equal number of votes - shouldn't happen very often
      points_in_first_category = points_by_category(first_category)
      points_in_complementary_category = points_by_category(complementary_category)
      if points_in_first_category > points_in_complementary_category
        return first_category
      elsif points_in_complementary_category > points_in_first_category
        return complementary_category
      else # point values in both categories are equal - return whichever category wins the tiebreaker (Actor or Actress) - should be very rare
        return first_category.tiebreaker_category
      end
    end
  end

end

