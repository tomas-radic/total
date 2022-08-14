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

ActiveRecord::Schema.define(version: 2022_07_05_105506) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "articles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.string "link"
    t.date "promote_until"
    t.uuid "manager_id", null: false
    t.uuid "season_id", null: false
    t.integer "color_base", null: false
    t.datetime "published_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "reactions_count", default: 0, null: false
    t.integer "comments_count", default: 0, null: false
    t.datetime "comments_disabled_since"
    t.index ["manager_id"], name: "index_articles_on_manager_id"
    t.index ["season_id"], name: "index_articles_on_season_id"
  end

  create_table "assignments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "player_id", null: false
    t.uuid "match_id", null: false
    t.integer "side", null: false
    t.boolean "is_retired", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["match_id"], name: "index_assignments_on_match_id"
    t.index ["player_id"], name: "index_assignments_on_player_id"
  end

  create_table "comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "commentable_type", null: false
    t.uuid "commentable_id", null: false
    t.uuid "player_id", null: false
    t.string "content", null: false
    t.integer "position"
    t.uuid "motive_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["motive_id"], name: "index_comments_on_motive_id"
    t.index ["player_id"], name: "index_comments_on_player_id"
  end

  create_table "enrollments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "player_id", null: false
    t.uuid "season_id", null: false
    t.datetime "canceled_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["player_id"], name: "index_enrollments_on_player_id"
    t.index ["season_id"], name: "index_enrollments_on_season_id"
  end

  create_table "managers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "access_denied_since"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_managers_on_email", unique: true
  end

  create_table "matches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.date "play_date"
    t.integer "play_time"
    t.string "notes"
    t.integer "kind", default: 0, null: false
    t.datetime "published_at"
    t.integer "winner_side"
    t.datetime "requested_at"
    t.datetime "accepted_at"
    t.datetime "rejected_at"
    t.datetime "reviewed_at"
    t.datetime "finished_at"
    t.boolean "ranking_counted", default: true, null: false
    t.string "competitable_type", null: false
    t.uuid "competitable_id", null: false
    t.uuid "place_id"
    t.integer "set1_side1_score"
    t.integer "set1_side2_score"
    t.integer "set2_side1_score"
    t.integer "set2_side2_score"
    t.integer "set3_side1_score"
    t.integer "set3_side2_score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "reactions_count", default: 0, null: false
    t.integer "comments_count", default: 0, null: false
    t.datetime "comments_disabled_since"
    t.datetime "predictions_disabled_since"
    t.datetime "canceled_at"
    t.uuid "canceled_by_id"
    t.index ["canceled_by_id"], name: "index_matches_on_canceled_by_id"
    t.index ["competitable_type", "competitable_id"], name: "index_matches_on_competitable"
    t.index ["place_id"], name: "index_matches_on_place_id"
  end

  create_table "places", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_places_on_name", unique: true
  end

  create_table "players", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.string "phone_nr"
    t.integer "birth_year"
    t.datetime "anonymized_at"
    t.datetime "access_denied_since"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "open_to_play_since"
    t.datetime "comments_disabled_since"
    t.datetime "cant_play_since"
    t.index ["email"], name: "index_players_on_email", unique: true
    t.index ["name"], name: "index_players_on_name", unique: true
    t.index ["phone_nr"], name: "index_players_on_phone_nr", unique: true
    t.index ["reset_password_token"], name: "index_players_on_reset_password_token", unique: true
  end

  create_table "predictions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "match_id", null: false
    t.uuid "player_id", null: false
    t.integer "side", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["match_id", "player_id"], name: "index_predictions_on_match_id_and_player_id", unique: true
    t.index ["match_id"], name: "index_predictions_on_match_id"
    t.index ["player_id"], name: "index_predictions_on_player_id"
  end

  create_table "reactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "player_id", null: false
    t.string "reactionable_type", null: false
    t.uuid "reactionable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["player_id"], name: "index_reactions_on_player_id"
    t.index ["reactionable_type", "reactionable_id"], name: "index_reactions_on_reactionable"
  end

  create_table "seasons", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.integer "play_off_size", default: 8, null: false
    t.integer "points_single_20", null: false
    t.integer "points_single_21", null: false
    t.integer "points_single_12", null: false
    t.integer "points_single_02", null: false
    t.integer "points_double_20", null: false
    t.integer "points_double_21", null: false
    t.integer "points_double_12", null: false
    t.integer "points_double_02", null: false
    t.integer "position", null: false
    t.datetime "ended_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tournaments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.date "begin_date"
    t.date "end_date"
    t.string "main_info", null: false
    t.text "side_info"
    t.integer "color_base", null: false
    t.datetime "published_at"
    t.uuid "season_id", null: false
    t.uuid "place_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "comments_disabled_since"
    t.string "draw_url"
    t.string "schedule_url"
    t.index ["place_id"], name: "index_tournaments_on_place_id"
    t.index ["season_id"], name: "index_tournaments_on_season_id"
  end

  add_foreign_key "articles", "managers"
  add_foreign_key "articles", "seasons"
  add_foreign_key "assignments", "matches"
  add_foreign_key "assignments", "players"
  add_foreign_key "comments", "players"
  add_foreign_key "enrollments", "players"
  add_foreign_key "enrollments", "seasons"
  add_foreign_key "matches", "places"
  add_foreign_key "predictions", "matches"
  add_foreign_key "predictions", "players"
  add_foreign_key "reactions", "players"
  add_foreign_key "tournaments", "places"
  add_foreign_key "tournaments", "seasons"
end
