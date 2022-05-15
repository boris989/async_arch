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

ActiveRecord::Schema[7.0].define(version: 2022_05_15_121328) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "task_statuses", ["open", "completed"]

  create_table "accounts", force: :cascade do |t|
    t.string "full_name"
    t.uuid "public_id"
    t.string "email"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "description"
    t.enum "status", default: "open", enum_type: "task_statuses"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "public_id", default: -> { "gen_random_uuid()" }, null: false
    t.string "title"
    t.string "jira_id"
    t.datetime "completed_at"
    t.index ["account_id"], name: "index_tasks_on_account_id"
  end

  add_foreign_key "tasks", "accounts"
end
