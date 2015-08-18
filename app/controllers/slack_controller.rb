class SlackController < ApplicationController
  def slash_command
    metrics = Metric.all.select { |m| m =~ params[:text] }

    if metrics.one?
      metrics.first.ping(text: params[:text], user: params[:user_name])
      render text: t("ping.confirmation")
    elsif metrics.none?
      render text: t("ping.no_matching_metrics"), status: :conflict
    else
      render text: t("ping.multiple_matching_metrics"), status: :conflict
    end
  end
end
