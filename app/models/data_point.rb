class DataPoint < ActiveRecord::Base
  belongs_to :metric, inverse_of: :data_points
  belongs_to :user, inverse_of: :data_points

  store_accessor :data

  validates :metric, presence: true, strict: true
  validates :number, :user, presence: true
  validates :number, numericality: true

  def self.from_slash_command(payload)
    metric = Metric.from_slash_command(payload)
    user = User.from_slash_command(payload)

    match = metric.regexp.match(payload[:text])
    number = match[:number] || 1
    data = payload.merge(Hash[match.names.zip(match.captures)])

    DataPoint.create(
      metric: metric,
      user: user,
      number: number,
      data: data
    )
  end
end
