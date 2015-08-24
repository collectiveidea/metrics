# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150824164252) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "hstore"

  create_table "data_points", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "metric_id",  null: false
    t.decimal  "number",     null: false
    t.hstore   "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid     "user_id"
  end

  add_index "data_points", ["created_at"], name: "index_data_points_on_created_at", using: :btree
  add_index "data_points", ["metadata"], name: "index_data_points_on_metadata", using: :gist
  add_index "data_points", ["metric_id"], name: "index_data_points_on_metric_id", using: :btree
  add_index "data_points", ["number"], name: "index_data_points_on_number", using: :btree
  add_index "data_points", ["user_id"], name: "index_data_points_on_user_id", using: :btree

  create_table "metrics", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.string   "pattern"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "help"
  end

  add_index "metrics", ["created_at"], name: "index_metrics_on_created_at", using: :btree

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "slack_id"
    t.string   "slack_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["slack_id"], name: "index_users_on_slack_id", unique: true, using: :btree

end
