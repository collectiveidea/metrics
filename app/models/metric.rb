class Metric < ActiveRecord::Base
  # Payloads from Slack's slash commands contain the following keys and are
  # merged into a data point's metadata. In order to avoid metadata collision,
  # named groups defined in a metric's pattern must not contain any of these
  # keys.
  RESERVED_NAMES = %w(
    channel_id
    channel_name
    command
    team_domain
    team_id
    text
    token
    user_id
    user_name
  )

  class NoMatch < StandardError; end
  class MultipleMatches < StandardError; end

  has_many :data_points, inverse_of: :metric, dependent: :delete_all

  validates :name, :pattern, presence: true
  validate :pattern_must_be_valid
  validate :pattern_must_not_contain_reserved_names, if: :valid_pattern?

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

  private

  def valid_pattern?
    regexp
  rescue RegexpError
    false
  else
    true
  end

  def pattern_must_be_valid
    errors.add(:pattern) unless valid_pattern?
  end

  def pattern_must_not_contain_reserved_names
    errors.add(:pattern) if (regexp.names & RESERVED_NAMES).any?
  end
end
