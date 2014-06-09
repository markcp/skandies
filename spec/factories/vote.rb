FactoryGirl.define do
  factory :vote do
    ballot
    category
    credit
    points 10
  end
end
