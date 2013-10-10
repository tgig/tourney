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

ActiveRecord::Schema.define(version: 20131008194118) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "players", force: true do |t|
    t.integer  "sbs_player_id"
    t.string   "first_name"
    t.string   "last_name"
    t.decimal  "handicap"
    t.integer  "tourney_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["tourney_id"], name: "index_players_on_tourney_id", using: :btree

  create_table "scorecards", force: true do |t|
    t.integer  "sbs_round_id"
    t.integer  "sbs_scorecard_id"
    t.string   "score_type_front_back_full"
    t.integer  "course_rating"
    t.integer  "course_slope"
    t.integer  "player_course_handicap"
    t.integer  "raw_score"
    t.integer  "handicap_adjusted_score"
    t.integer  "stableford_score"
    t.string   "round_track_url"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "course_name"
    t.string   "course_city"
    t.string   "course_state"
    t.string   "course_country"
    t.datetime "round_date"
    t.string   "tee_box"
  end

  add_index "scorecards", ["player_id"], name: "index_scorecards_on_player_id", using: :btree

  create_table "tourneys", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "startdate"
    t.datetime "enddate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
