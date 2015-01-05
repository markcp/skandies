class TopTenList < ActiveRecord::Base
  has_many :top_ten_entries
  belongs_to :ballot
  accepts_nested_attributes_for :top_ten_entries

  validates :ballot_id, presence: true
  validate :has_ten_entries
  validate :has_correct_ranks

  def has_ten_entries
    errors.add(:top_ten_entry, "Must have exacty ten entries") unless top_ten_entries.length == 10
  end

  def has_correct_ranks
    unranked_list = false
    top_ten_entries.each do |tte|
      if tte.rank == 0
        unranked_list = true
      end
    end
    if unranked_list
      top_ten_entries.each do |tte|
        errors.add(:ranked, "List must be ranked 1-10 or marked with all zeroes for an unranked list.") unless tte.rank == 0
      end
    else
      ranks_array = []
      top_ten_entries.each do |tte|
        ranks_array << tte.rank
      end
      errors.add(:ranked, "List must be ranked 1-10 or marked with all zeroes for an unranked list.") unless ranks_array == [1,2,3,4,5,6,7,8,9,10]
    end
  end

  def valid_for_submission?
    top_ten_entries.length == 10
  end

end
