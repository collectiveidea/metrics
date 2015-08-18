FactoryGirl.define do
  factory :data_point do
    trait :tally do
      tally
      number 1
      user "jane"
    end
  end
end
