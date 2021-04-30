# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_30_185135) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "epoch_delegations_flows", force: :cascade do |t|
    t.integer "epochno"
    t.text "json"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "epoch_records", force: :cascade do |t|
    t.integer "epoch_no"
    t.bigint "supply"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pool_epoches", force: :cascade do |t|
    t.integer "blocks"
    t.bigint "total_stakes"
    t.bigint "size"
    t.integer "pool_hash_id"
    t.integer "pool_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "epoch_no"
    t.string "ticker"
  end

  create_table "pools", force: :cascade do |t|
    t.string "ticker"
    t.string "url"
    t.integer "pool_hash_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "hash_hex"
    t.string "pool_addr"
    t.string "description"
    t.string "name"
    t.string "homepage"
  end

  create_table "user_pool_hashes", force: :cascade do |t|
    t.integer "pool_hash_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_stakes", force: :cascade do |t|
    t.integer "user_id"
    t.string "stake_address_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "email"
    t.string "uid"
    t.string "provider"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
