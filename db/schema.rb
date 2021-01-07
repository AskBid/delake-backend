# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_07_180842) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "epoch_delegations_flows", force: :cascade do |t|
    t.integer "epochno"
    t.text "json"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pools", force: :cascade do |t|
    t.string "ticker"
    t.string "url"
    t.integer "pool_hash_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "hash_hex"
    t.string "pool_addr"
  end

end
