class User < ActiveRecord::Base

  has_many :ballots

  validates :last_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  def name
    if first_name
      first_name + " " + last_name
    else
      last_name
    end
  end
end
