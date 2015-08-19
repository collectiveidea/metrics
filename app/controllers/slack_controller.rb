class SlackController < ApplicationController
  def slash_command
    DataPoint.from_slash_command(request.request_parameters)

    render text: t("ping.created"), status: :created
  rescue Metric::NoMatch
    render text: t("ping.no_match"), status: :unprocessable_entity
  rescue Metric::MultipleMatches
    render text: t("ping.multiple_matches"), status: :conflict
  end
end
