class CreateDataPoints < ActiveRecord::Migration
  def change
    enable_extension "hstore"

    create_table :data_points, id: :uuid do |t|
      t.uuid :metric_id, null: false
      t.decimal :number, null: false
      t.hstore :data
      t.timestamps null: false
    end

    add_index :data_points, :metric_id
    add_index :data_points, :number
    add_index :data_points, :data, using: :gist
    add_index :data_points, :created_at
  end
end
