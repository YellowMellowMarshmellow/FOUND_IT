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

ActiveRecord::Schema[7.1].define(version: 2025_07_12_093347) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "claims", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "message"
    t.string "category"
    t.text "description"
    t.string "title"
    t.string "locations"
    t.date "date_reported"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_claims_on_user_id"
  end

  create_table "found_items", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "location"
    t.string "category"
    t.date "date_reported"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_found_items_on_user_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "claim_id", null: false
    t.bigint "found_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["claim_id"], name: "index_matches_on_claim_id"
    t.index ["found_item_id"], name: "index_matches_on_found_item_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "claims", "users"
  add_foreign_key "found_items", "users"
  add_foreign_key "matches", "claims"
  add_foreign_key "matches", "found_items"
end
