FactoryGirl.define do
  factory :year do
    name "2013"
  end

  factory :movie do
    title "The Past"
    year
  end

  factory :person do
    first_name "Berenice"
    last_name "Bejo"
    gender "F"
  end

  factory :job do
    name "Actor"
  end

  factory :credit do
    movie
    person
    job
    year
  end

  factory :scene do
    movie
    title "A stirring scene"
    year
  end

  factory :user do
    first_name "Example"
    last_name "User"
    email "user@example.com"
  end

  factory :ballot do
    user
    year
    complete false
  end

  factory :category do
    name "Actor"
  end

  factory :best_picture_category, class: Category do
    name "Picture"
  end

  factory :vote do
    ballot
    category
    credit
    points 10
  end

  factory :best_picture_vote, class: Vote do
    ballot
    category
    movie
    points 10
  end
end
