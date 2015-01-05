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

ActiveRecord::Schema.define(version: 20150102171029) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ballots", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "year_id"
    t.boolean  "complete",                                      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "nbr_ratings"
    t.decimal  "average_rating",        precision: 3, scale: 2
    t.integer  "four_ratings"
    t.integer  "three_pt_five_ratings"
    t.integer  "three_ratings"
    t.integer  "two_pt_five_ratings"
    t.integer  "two_ratings"
    t.integer  "one_pt_five_ratings"
    t.integer  "one_ratings"
    t.integer  "zero_ratings"
    t.integer  "selectivity_index"
  end

  add_index "ballots", ["user_id", "complete"], name: "index_ballots_on_user_id_and_complete", using: :btree
  add_index "ballots", ["year_id", "complete"], name: "index_ballots_on_year_id_and_complete", using: :btree
  add_index "ballots", ["year_id", "nbr_ratings"], name: "index_ballots_on_year_id_and_nbr_ratings", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_vote_groups", force: :cascade do |t|
    t.integer  "ballot_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "credits", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "movie_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year_id"
    t.integer  "results_category_id"
    t.integer  "points"
    t.integer  "nbr_votes"
  end

  add_index "credits", ["job_id"], name: "index_credits_on_job_id", using: :btree
  add_index "credits", ["movie_id"], name: "index_credits_on_movie_id", using: :btree
  add_index "credits", ["person_id"], name: "index_credits_on_person_id", using: :btree
  add_index "credits", ["year_id", "results_category_id", "points", "nbr_votes"], name: "index_credits_on_results_fields", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movies", force: :cascade do |t|
    t.string   "title",                 limit: 255
    t.string   "title_index",           limit: 255
    t.integer  "year_id"
    t.string   "director_display",      limit: 255
    t.string   "screenwriter_display",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "picture_points"
    t.integer  "picture_votes"
    t.integer  "director_points"
    t.integer  "director_votes"
    t.integer  "screenplay_points"
    t.integer  "screenplay_votes"
    t.integer  "nbr_ratings"
    t.decimal  "average_rating",                    precision: 3, scale: 2
    t.integer  "four_ratings"
    t.integer  "three_pt_five_ratings"
    t.integer  "three_ratings"
    t.integer  "two_pt_five_ratings"
    t.integer  "two_ratings"
    t.integer  "one_pt_five_ratings"
    t.integer  "one_ratings"
    t.integer  "zero_ratings"
    t.decimal  "standard_dev",                      precision: 3, scale: 2
  end

  add_index "movies", ["year_id", "average_rating"], name: "index_movies_on_year_id_and_average_rating", using: :btree
  add_index "movies", ["year_id", "director_points", "director_votes"], name: "index_movies_on_director_results_fields", using: :btree
  add_index "movies", ["year_id", "picture_points", "picture_votes"], name: "index_movies_on_picture_results_fields", using: :btree
  add_index "movies", ["year_id", "screenplay_points", "screenplay_votes"], name: "index_movies_on_screenplay_results_fields", using: :btree
  add_index "movies", ["year_id", "title_index"], name: "index_movies_on_year_id_and_title_index", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "first_name",      limit: 255
    t.string   "last_name",       limit: 255
    t.string   "gender",          limit: 255
    t.boolean  "last_name_first",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "ballot_id"
    t.integer  "movie_id"
    t.decimal  "value",            precision: 2, scale: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ratings_group_id"
  end

  add_index "ratings", ["ballot_id"], name: "index_ratings_on_ballot_id", using: :btree
  add_index "ratings", ["movie_id"], name: "index_ratings_on_movie_id", using: :btree

  create_table "ratings_groups", force: :cascade do |t|
    t.integer  "ballot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scenes", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.integer  "movie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year_id"
    t.integer  "points"
    t.integer  "nbr_votes"
  end

  add_index "scenes", ["year_id", "points", "nbr_votes"], name: "index_scenes_on_year_id_and_points_and_nbr_votes", using: :btree

  create_table "top_ten_entries", force: :cascade do |t|
    t.integer  "ballot_id"
    t.string   "value",           limit: 255
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "top_ten_list_id"
  end

  add_index "top_ten_entries", ["ballot_id"], name: "index_top_ten_entries_on_ballot_id", using: :btree

  create_table "top_ten_lists", force: :cascade do |t|
    t.integer  "ballot_id"
    t.boolean  "ranked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",      limit: 255
    t.string   "last_name",       limit: 255
    t.string   "email",           limit: 255
    t.boolean  "admin",                       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["last_name"], name: "index_users_on_last_name", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "ballot_id"
    t.integer  "category_id"
    t.integer  "credit_id"
    t.integer  "movie_id"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "scene_id"
    t.string   "value"
    t.integer  "category_vote_group_id"
  end

  add_index "votes", ["ballot_id", "category_id"], name: "index_votes_on_ballot_id_and_category_id", using: :btree
  add_index "votes", ["category_id"], name: "index_votes_on_category_id", using: :btree
  add_index "votes", ["credit_id"], name: "index_votes_on_credit_id", using: :btree
  add_index "votes", ["movie_id"], name: "index_votes_on_movie_id", using: :btree
  add_index "votes", ["value"], name: "index_votes_on_value", using: :btree

  create_table "years", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.datetime "open_voting",                 default: '2001-01-01 00:00:00'
    t.datetime "close_voting",                default: '2001-01-01 00:00:00'
    t.datetime "display_results",             default: '2001-01-01 00:00:00'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
