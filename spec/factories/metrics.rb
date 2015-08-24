FactoryGirl.define do
  factory :metric do
    name "My Metric"
    pattern "(foo|bar)"
    help "foo"
    feedback "Thank you!"
  end
end
