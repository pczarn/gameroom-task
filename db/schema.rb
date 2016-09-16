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

ActiveRecord::Schema.define(version: 20160916101106) do

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
    t.datetime "played_at"
    t.integer  "game_id",        null: false
    t.integer  "team_one_id",    null: false
    t.integer  "team_two_id",    null: false
    t.integer  "team_one_score"
    t.integer  "team_two_score"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "round_id"
    t.index ["game_id"], name: "index_matches_on_game_id", using: :btree
    t.index ["round_id"], name: "index_matches_on_round_id", using: :btree
    t.index ["team_one_id"], name: "index_matches_on_team_one_id", using: :btree
    t.index ["team_two_id"], name: "index_matches_on_team_two_id", using: :btree
  end

  create_table "rounds", force: :cascade do |t|
    t.integer  "tournament_id", null: false
    t.integer  "number",        null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["tournament_id", "number"], name: "index_rounds_on_tournament_id_and_number", unique: true, using: :btree
    t.index ["tournament_id"], name: "index_rounds_on_tournament_id", using: :btree
  end

  create_table "team_tournaments", force: :cascade do |t|
    t.integer  "team_id",       null: false
    t.integer  "tournament_id", null: false
    t.integer  "size_limit"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["team_id", "tournament_id"], name: "index_team_tournaments_on_team_id_and_tournament_id", unique: true, using: :btree
    t.index ["team_id"], name: "index_team_tournaments_on_team_id", using: :btree
    t.index ["tournament_id"], name: "index_team_tournaments_on_tournament_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_teams_on_name", unique: true, using: :btree
  end

  create_table "tournaments", force: :cascade do |t|
    t.string   "title",                                  null: false
    t.string   "description"
    t.integer  "game_id",                                null: false
    t.integer  "owner_id",                               null: false
    t.integer  "status",                     default: 0, null: false
    t.integer  "number_of_teams",                        null: false
    t.integer  "number_of_members_per_team"
    t.datetime "started_at",                             null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "image"
    t.index ["game_id"], name: "index_tournaments_on_game_id", using: :btree
    t.index ["owner_id"], name: "index_tournaments_on_owner_id", using: :btree
    t.index ["title"], name: "index_tournaments_on_title", unique: true, using: :btree
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
    t.string   "name",                        null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "email",                       null: false
    t.string   "password_hashed",             null: false
    t.integer  "role",            default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["name"], name: "index_users_on_name", unique: true, using: :btree
  end

  add_foreign_key "matches", "games"
  add_foreign_key "matches", "rounds"
  add_foreign_key "rounds", "tournaments"
  add_foreign_key "team_tournaments", "teams"
  add_foreign_key "team_tournaments", "tournaments"
  add_foreign_key "tournaments", "games"
  add_foreign_key "tournaments", "users", column: "owner_id"
  add_foreign_key "user_teams", "teams"
  add_foreign_key "user_teams", "users"
end
