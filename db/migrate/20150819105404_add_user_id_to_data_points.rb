class AddUserIdToDataPoints < ActiveRecord::Migration
  def change
    add_column :data_points, :user_id, :uuid
    add_index :data_points, :user_id
  end
end
