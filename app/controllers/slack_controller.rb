class SlackController < ApplicationController
  def slash_command
    metric = Metric.match(params[:text])
    metric.ping(text: params[:text], user: params[:user_name])

    render text: t("ping.created"), status: :created
  rescue Metric::NoMatch
    render text: t("ping.no_match"), status: :unprocessable_entity
  rescue Metric::MultipleMatches
    render text: t("ping.multiple_matches"), status: :conflict
  end
end
