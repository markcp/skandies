class Person < ActiveRecord::Base
  has_many :credits

  validates :last_name, presence: true
  validates :gender, inclusion: [ 'M', 'F', 'O' ], allow_nil: true
  validates :last_name_first, inclusion: [ true, false ]

  def name
    if last_name_first
      "#{last_name} #{first_name}"
    else
      "#{first_name} #{last_name}"
    end
  end

end
