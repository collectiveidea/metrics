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

ActiveRecord::Schema.define(version: 20150818223041) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "hstore"

  create_table "data_points", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "metric_id",  null: false
    t.decimal  "number",     null: false
    t.hstore   "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "data_points", ["created_at"], name: "index_data_points_on_created_at", using: :btree
  add_index "data_points", ["data"], name: "index_data_points_on_data", using: :gist
  add_index "data_points", ["metric_id"], name: "index_data_points_on_metric_id", using: :btree
  add_index "data_points", ["number"], name: "index_data_points_on_number", using: :btree

  create_table "metrics", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.string   "pattern"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "metrics", ["created_at"], name: "index_metrics_on_created_at", using: :btree

end
