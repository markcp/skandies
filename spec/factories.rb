FactoryGirl.define do
  factory :movie do
    title "The Past"
    year "2013"
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
  end
end
