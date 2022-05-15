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

ActiveRecord::Schema[7.0].define(version: 2022_05_15_060130) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "transaction_kinds", ["enrollment", "withdrawal", "payment"]

  create_table "accounts", force: :cascade do |t|
    t.string "full_name"
    t.uuid "public_id"
    t.string "email"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "balances", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.decimal "amount", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_balances_on_account_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.uuid "public_id"
    t.string "title"
    t.string "jira_id"
    t.string "description"
    t.string "status"
    t.decimal "cost", precision: 4, scale: 2
    t.decimal "fee", precision: 4, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_tasks_on_account_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.uuid "public_id", default: -> { "gen_random_uuid()" }, null: false
    t.decimal "amount"
    t.enum "kind", null: false, enum_type: "transaction_kinds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["account_id"], name: "index_transactions_on_account_id"
  end

  add_foreign_key "balances", "accounts"
  add_foreign_key "tasks", "accounts"
  add_foreign_key "transactions", "accounts"
end
