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

ActiveRecord::Schema.define(version: 20160914083715) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "image"
    t.index ["name"], name: "index_games_on_name", unique: true, using: :btree
  end

  create_table "matches", force: :cascade do |t|
    t.datetime "played_at",      null: false
    t.integer  "game_id",        null: false
    t.integer  "team_one_id",    null: false
    t.integer  "team_two_id",    null: false
    t.integer  "team_one_score"
    t.integer  "team_two_score"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["game_id"], name: "index_matches_on_game_id", using: :btree
    t.index ["team_one_id"], name: "index_matches_on_team_one_id", using: :btree
    t.index ["team_two_id"], name: "index_matches_on_team_two_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_teams_on_name", unique: true, using: :btree
  end

  create_table "user_teams", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "team_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_user_teams_on_team_id", using: :btree
    t.index ["user_id", "team_id"], name: "index_user_teams_on_user_id_and_team_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_teams_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "email"
    t.string   "password_hashed"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["name"], name: "index_users_on_name", unique: true, using: :btree
  end

  add_foreign_key "matches", "games"
  add_foreign_key "user_teams", "teams"
  add_foreign_key "user_teams", "users"
end
