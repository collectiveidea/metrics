class AddExampleToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :example, :string
  end
end
