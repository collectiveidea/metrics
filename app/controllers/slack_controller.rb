class SlackController < ApplicationController
  def slash_command
    DataPoint.from_slash_command(request.request_parameters)

    render text: t("slash_command.data_point.created"), status: :created
  rescue Metric::NoMatch
    render text: t("slash_command.metric.no_match"), status: :unprocessable_entity
  rescue Metric::MultipleMatches
    render text: t("slash_command.metric.multiple_matches"), status: :conflict
  rescue User::NoMatch
    render text: t("slash_command.user.no_match"), status: :unprocessable_entity
  end
end
