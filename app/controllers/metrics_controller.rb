class MetricsController < ApplicationController
  before_action :load_metric, only: [:show, :edit, :update, :graph]
  before_action :load_graph, only: [:show, :graph]

  def index
    @metrics = Metric.by_latest_data_point
  end

  def show
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

  def edit
  end

  def update
    if @metric.update(metric_params)
      redirect_to metrics_path
    else
      render :edit
    end
  end

  def destroy
    Metric.destroy(params[:id])

    redirect_to metrics_path
  end

  def preview
    metadata = Metric.preview_metadata(
      pattern: params[:pattern],
      command: params[:command]
    )

    render json: metadata
  end

  def graph
    render partial: "graph"
  end

  private

  def metric_params
    params.require(:metric).permit(:name, :pattern, :help, :feedback)
  end

  def load_metric
    @metric = Metric.find(params[:id])
  end

  def load_graph
    days = params[:days].presence.try(:to_i) || 30
    metadata_name = params[:metadata_name].presence

    @graph = @metric.graph(days: days, metadata_name: metadata_name)
  end
end
