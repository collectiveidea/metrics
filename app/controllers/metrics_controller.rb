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

  def edit
    @metric = Metric.find(params[:id])
  end

  def update
    @metric = Metric.find(params[:id])

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

  private

  def metric_params
    params.require(:metric).permit(:name, :pattern, :help, :feedback)
  end
end
