class AddLatestDataPointAtToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :latest_data_point_at, :datetime
    add_index :metrics, :latest_data_point_at
  end
end
