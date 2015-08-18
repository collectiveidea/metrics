class MetricsController < ApplicationController
  def index
    @metrics = Metric.all
  end

  def show
    @metric = Metric.find(params[:id])
  end

  def new
    @metric = Metric.new
  end

  def create
    @metric = Metric.new(metric_params)

    if @metric.save
      redirect_to metrics_path
    else
      render :new
    end
  end

  private

  def metric_params
    params.require(:metric).permit(:name, :pattern)
  end
end
