FactoryGirl.define do
  factory :data_point do
    metric
    number 1
    user "jane"
  end
end
