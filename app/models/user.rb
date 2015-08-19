class User < ActiveRecord::Base
  has_many :data_points, inverse_of: :user, dependent: :delete_all

  validates :slack_id, presence: true, uniqueness: true
  validates :slack_name, presence: true

  def self.from_slash_command(payload)
    User.find_or_initialize_by(slack_id: payload[:user_id]).tap do |user|
      user.slack_name = payload[:user_name]
      user.save!
    end
  end
end
