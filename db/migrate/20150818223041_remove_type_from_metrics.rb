class RemoveTypeFromMetrics < ActiveRecord::Migration
  def up
    remove_column :metrics, :type
  end

  def down
    add_column :metrics, :type, :string
    execute "UPDATE metrics SET type = 'Metric'"
  end
end
