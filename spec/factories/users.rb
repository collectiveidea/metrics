FactoryGirl.define do
  factory :user do
    slack_id { SecureRandom.urlsafe_base64 }
    slack_name "jane"
  end
end
