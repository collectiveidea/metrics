class AddDataPointsCountToMetrics < ActiveRecord::Migration
  class Metric < ActiveRecord::Base
    has_many :data_points
  end

  class DataPoint < ActiveRecord::Base
    belongs_to :metric, counter_cache: true
  end

  def up
    add_column :metrics, :data_points_count, :integer, default: 0, null: false

    Metric.pluck(:id).each { |id| Metric.reset_counters(id, :data_points) }
  end

  def down
    remove_column :metrics, :data_points_count
  end
end
