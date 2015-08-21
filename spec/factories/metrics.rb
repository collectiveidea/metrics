FactoryGirl.define do
  factory :metric do
    name "My Metric"
    pattern "(foo|bar)"
    example "foo"
  end
end
