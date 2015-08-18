class CreateMetrics < ActiveRecord::Migration
  def change
    enable_extension "uuid-ossp"

    create_table :metrics, id: :uuid do |t|
      t.string :type
      t.string :name
      t.string :pattern
      t.timestamps null: false
    end

    add_index :metrics, :type
    add_index :metrics, :created_at
  end
end
