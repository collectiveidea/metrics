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

  validates :name, :pattern, :help, :feedback, presence: true
  validate :pattern_must_be_valid
  validate :pattern_must_not_contain_reserved_names, if: :valid_pattern?
  validate :feedback_must_not_contain_unknown_names, if: :valid_pattern?

  delegate :=~, to: :regexp

  def self.from_slash_command(payload)
    metrics = where(":text ~* regexp_replace(pattern, '\\?<\\w+>', '', 'g')", text: payload[:text]).to_a

    raise NoMatch if metrics.none?
    raise MultipleMatches if metrics.many?

    metrics.first
  end

  def self.preview_metadata(pattern:, command:)
    metric = new(pattern: pattern)
    return {} unless metric.valid_pattern?

    regexp = metric.regexp
    match = regexp.match(command)
    return {} unless match

    regexp.names.inject({}) { |h, n| h[n] = match[n]; h }
  end

  def regexp
    Regexp.new(pattern, true)
  end

  def valid_pattern?
    regexp
  rescue RegexpError
    false
  else
    true
  end

  private

  def pattern_must_be_valid
    errors.add(:pattern) unless valid_pattern?
  end

  def pattern_must_not_contain_reserved_names
    reserved_names = regexp.names & RESERVED_NAMES

    if reserved_names.any?
      errors.add(:pattern, <<-MSG.squish)
        must not contain the group
        #{"name".pluralize(reserved_names.size)}:
        #{reserved_names.join(", ")}
        MSG
    end
  end

  def feedback_must_not_contain_unknown_names
    return if feedback.blank?

    metadata = regexp.names.inject({}) { |h, n| h[n.to_sym] = true; h }
    feedback % metadata
  rescue KeyError
    errors.add(:feedback)
  end
end
