class Metric < ActiveRecord::Base
  class NoMatch < StandardError; end
  class MultipleMatches < StandardError; end

  has_many :data_points, inverse_of: :metric, dependent: :delete_all

  validates :name, :pattern, presence: true
  validate :pattern_must_be_valid

  delegate :=~, to: :regexp

  def self.from_slash_command(payload)
    metrics = where(":text ~ regexp_replace(pattern, '\\?<\\w+>', '', 'g')", text: payload[:text]).to_a

    raise NoMatch if metrics.none?
    raise MultipleMatches if metrics.many?

    metrics.first
  end

  def regexp
    Regexp.new(pattern)
  end

  def ping(text:, user:)
    match = regexp.match(text)
    number = match[:number] || 1
    data = Hash[match.names.zip(match.captures)]
    data["user"] = match[:user] || user

    data_points.create!(number: number, data: data)
  end

  private

  def pattern_must_be_valid
    regexp
  rescue RegexpError
    errors.add(:pattern)
  end
end
