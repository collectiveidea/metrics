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

  def self.by_latest_data_point
    order("metrics.latest_data_point_at DESC NULLS LAST, metrics.created_at ASC")
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

  def graph(days:, metadata_name: nil)
    range = days.days.ago.beginning_of_day..Time.current.end_of_day
    data = data_points.where(created_at: range)

    if metadata_name
      metadata_value = "metadata -> '#{metadata_name}'"
      data = data.order("#{metadata_value} NULLS LAST").group(metadata_value)
    end

    format = I18n.translate!("date.formats.graph")
    json = data
      .group_by_day(:created_at, format: format)
      .sum(:number)
      .chart_json

    # The groupdate gem outputs a JSON string from the chart_json method. We
    # want the origial Ruby hash.
    JSON.load(json)
  end

  def metadata_names
    regexp.names
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

    all_metadata_names = metadata_names + RESERVED_NAMES
    metadata = all_metadata_names.inject({}) { |h, n| h[n.to_sym] = true; h }
    feedback % metadata
  rescue KeyError
    errors.add(:feedback)
  end
end
