class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:slash_command]

  def slash_command
    case params[:text]
    when "", "help"
      @metrics = Metric.by_latest_data_point
      render :help
    else
      data_point = DataPoint.from_slash_command(request.request_parameters)
      render text: data_point.feedback, status: :created
    end
  rescue Metric::NoMatch
    render text: t("slash_command.metric.no_match"), status: :unprocessable_entity
  rescue Metric::MultipleMatches
    render text: t("slash_command.metric.multiple_matches"), status: :conflict
  rescue User::NoMatch
    render text: t("slash_command.user.no_match"), status: :unprocessable_entity
  end
end
