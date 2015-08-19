class RenameDataToMetadata < ActiveRecord::Migration
  def change
    rename_column :data_points, :data, :metadata
  end
end
