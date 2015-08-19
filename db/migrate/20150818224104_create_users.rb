class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid do |t|
      t.string :slack_id
      t.string :slack_name
      t.timestamps null: false
    end

    add_index :users, :slack_id, unique: true
  end
end
