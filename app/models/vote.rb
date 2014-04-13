class Vote < ActiveRecord::Base

  belongs_to :ballot
  belongs_to :category
  belongs_to :credit
  belongs_to :movie

  validate :one_value_only
  validates :ballot_id, presence: true
  validates :category_id, presence: true
  validates :points, presence: true

  def one_value_only
    value_array = [self.credit_id, self.movie_id, self.value].compact.delete_if { |v| v.blank? }

    if value_array.size > 1
      errors.add(:value, "More than one value provided." + value_array.to_s)
    elsif value_array.size < 1
      errors.add(:value, "Must have a value.")
    end
  end
end
