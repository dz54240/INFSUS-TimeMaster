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

ActiveRecord::Schema[7.1].define(version: 2025_05_13_233544) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "employments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_employments_on_organization_id"
    t.index ["user_id", "organization_id"], name: "index_employments_on_user_id_and_organization_id", unique: true
  end

  create_table "invitations", force: :cascade do |t|
    t.string "token"
    t.boolean "token_used", default: false, null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_invitations_on_organization_id"
    t.index ["token"], name: "index_invitations_on_token", unique: true
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.date "established_at"
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_organizations_on_owner_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.date "start_date"
    t.date "end_date"
    t.decimal "budget_amount", precision: 10, scale: 2
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_projects_on_organization_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "token"
    t.bigint "user_id", null: false
    t.datetime "expired_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_sessions_on_token", unique: true
  end

  create_table "team_memberships", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_memberships_on_team_id"
    t.index ["user_id", "team_id"], name: "index_team_memberships_on_user_id_and_team_id", unique: true
    t.index ["user_id"], name: "index_team_memberships_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_teams_on_organization_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", null: false
    t.string "role", null: false
    t.text "password_digest"
    t.date "birth_date"
    t.decimal "hourly_rate", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "work_logs", force: :cascade do |t|
    t.datetime "start_time", precision: nil, null: false
    t.datetime "end_time", precision: nil, null: false
    t.string "activity_type", null: false
    t.text "description"
    t.decimal "cost", precision: 10, scale: 2
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_work_logs_on_project_id"
    t.index ["user_id"], name: "index_work_logs_on_user_id"
  end

  add_foreign_key "employments", "organizations"
  add_foreign_key "employments", "users"
  add_foreign_key "invitations", "organizations"
  add_foreign_key "organizations", "users", column: "owner_id"
  add_foreign_key "projects", "organizations"
  add_foreign_key "sessions", "users"
  add_foreign_key "team_memberships", "teams"
  add_foreign_key "team_memberships", "users"
  add_foreign_key "teams", "organizations"
  add_foreign_key "work_logs", "projects"
  add_foreign_key "work_logs", "users"
end
