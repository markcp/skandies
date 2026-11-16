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

ActiveRecord::Schema[7.0].define(version: 2026_11_16_011649) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ballots", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "year_id"
    t.boolean "complete", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "nbr_ratings"
    t.decimal "average_rating", precision: 3, scale: 2
    t.integer "four_ratings"
    t.integer "three_pt_five_ratings"
    t.integer "three_ratings"
    t.integer "two_pt_five_ratings"
    t.integer "two_ratings"
    t.integer "one_pt_five_ratings"
    t.integer "one_ratings"
    t.integer "zero_ratings"
    t.integer "selectivity_index"
    t.index ["user_id", "complete"], name: "index_ballots_on_user_id_and_complete"
    t.index ["year_id", "complete"], name: "index_ballots_on_year_id_and_complete"
    t.index ["year_id", "nbr_ratings"], name: "index_ballots_on_year_id_and_nbr_ratings"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "category_vote_groups", id: :serial, force: :cascade do |t|
    t.integer "ballot_id"
    t.integer "category_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "credits", id: :serial, force: :cascade do |t|
    t.integer "person_id"
    t.integer "movie_id"
    t.integer "job_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "year_id"
    t.integer "results_category_id"
    t.integer "points"
    t.integer "nbr_votes"
    t.index ["job_id"], name: "index_credits_on_job_id"
    t.index ["movie_id"], name: "index_credits_on_movie_id"
    t.index ["person_id"], name: "index_credits_on_person_id"
    t.index ["year_id", "results_category_id", "points", "nbr_votes"], name: "index_credits_on_results_fields"
  end

  create_table "jobs", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "movies", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.string "title_index", limit: 255
    t.integer "year_id"
    t.string "director_display", limit: 255
    t.string "screenwriter_display", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "picture_points"
    t.integer "picture_votes"
    t.integer "director_points"
    t.integer "director_votes"
    t.integer "screenplay_points"
    t.integer "screenplay_votes"
    t.integer "nbr_ratings"
    t.decimal "average_rating", precision: 5, scale: 4
    t.integer "four_ratings"
    t.integer "three_pt_five_ratings"
    t.integer "three_ratings"
    t.integer "two_pt_five_ratings"
    t.integer "two_ratings"
    t.integer "one_pt_five_ratings"
    t.integer "one_ratings"
    t.integer "zero_ratings"
    t.decimal "standard_dev", precision: 3, scale: 2
    t.index ["year_id", "average_rating"], name: "index_movies_on_year_id_and_average_rating"
    t.index ["year_id", "director_points", "director_votes"], name: "index_movies_on_director_results_fields"
    t.index ["year_id", "picture_points", "picture_votes"], name: "index_movies_on_picture_results_fields"
    t.index ["year_id", "screenplay_points", "screenplay_votes"], name: "index_movies_on_screenplay_results_fields"
    t.index ["year_id", "title_index"], name: "index_movies_on_year_id_and_title_index"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "gender", limit: 255
    t.boolean "last_name_first", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "ratings", id: :serial, force: :cascade do |t|
    t.integer "ballot_id"
    t.integer "movie_id"
    t.decimal "value", precision: 2, scale: 1
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "ratings_group_id"
    t.index ["ballot_id"], name: "index_ratings_on_ballot_id"
    t.index ["movie_id"], name: "index_ratings_on_movie_id"
  end

  create_table "ratings_groups", id: :serial, force: :cascade do |t|
    t.integer "ballot_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "scenes", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.integer "movie_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "year_id"
    t.integer "points"
    t.integer "nbr_votes"
    t.index ["year_id", "points", "nbr_votes"], name: "index_scenes_on_year_id_and_points_and_nbr_votes"
  end

  create_table "top_ten_entries", id: :serial, force: :cascade do |t|
    t.integer "ballot_id"
    t.string "value", limit: 255
    t.integer "rank"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "top_ten_list_id"
    t.index ["ballot_id"], name: "index_top_ten_entries_on_ballot_id"
  end

  create_table "top_ten_lists", id: :serial, force: :cascade do |t|
    t.integer "ballot_id"
    t.boolean "ranked"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "email", limit: 255
    t.boolean "admin", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "password_digest"
    t.string "remember_digest"
    t.string "reset_digest"
    t.datetime "reset_sent_at", precision: nil
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["last_name"], name: "index_users_on_last_name"
  end

  create_table "votes", id: :serial, force: :cascade do |t|
    t.integer "ballot_id"
    t.integer "category_id"
    t.integer "credit_id"
    t.integer "movie_id"
    t.integer "points"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "scene_id"
    t.string "value"
    t.integer "category_vote_group_id"
    t.index ["ballot_id", "category_id"], name: "index_votes_on_ballot_id_and_category_id"
    t.index ["category_id"], name: "index_votes_on_category_id"
    t.index ["credit_id"], name: "index_votes_on_credit_id"
    t.index ["movie_id"], name: "index_votes_on_movie_id"
    t.index ["value"], name: "index_votes_on_value"
  end

  create_table "years", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "open_voting", precision: nil, default: "2001-01-01 00:00:00"
    t.datetime "close_voting", precision: nil, default: "2001-01-01 00:00:00"
    t.datetime "display_results", precision: nil, default: "2001-01-01 00:00:00"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

end
