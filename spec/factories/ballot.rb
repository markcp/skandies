FactoryGirl.define do
  factory :ballot do
    user
    year
    complete false
  end
end
