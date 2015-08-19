class User < ActiveRecord::Base
  class NoMatch < StandardError; end

  has_many :data_points, inverse_of: :user, dependent: :delete_all

  validates :slack_id, presence: true, uniqueness: true
  validates :slack_name, presence: true

  def self.from_slash_command(payload, metric: nil)
    metric ||= Metric.from_slash_command(payload)
    match = metric.regexp.match(payload[:text])

    if match.names.include?("user") && match[:user]
      find_by(slack_name: match[:user]) || raise(NoMatch)
    else
      User.find_or_initialize_by(slack_id: payload[:user_id]).tap do |user|
        user.slack_name = payload[:user_name]
        user.save!
      end
    end
  end
end
