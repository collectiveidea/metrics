FactoryGirl.define do
  factory :metric do
    sequence(:name) { |n| "metric #{n}" }
    pattern "(foo|bar)"
    help "foo"
    feedback "Thank you!"
  end
end
