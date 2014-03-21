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

ActiveRecord::Schema.define(version: 20140321184053) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ballots", force: true do |t|
    t.integer  "user_id"
    t.string   "year_id"
    t.boolean  "complete",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ballots", ["user_id", "complete"], name: "index_ballots_on_user_id_and_complete", using: :btree
  add_index "ballots", ["year_id", "complete"], name: "index_ballots_on_year_id_and_complete", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credits", force: true do |t|
    t.integer  "person_id"
    t.integer  "movie_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credits", ["job_id"], name: "index_credits_on_job_id", using: :btree
  add_index "credits", ["movie_id"], name: "index_credits_on_movie_id", using: :btree
  add_index "credits", ["person_id"], name: "index_credits_on_person_id", using: :btree

  create_table "jobs", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movies", force: true do |t|
    t.string   "title"
    t.string   "title_index"
    t.string   "year_id"
    t.string   "director_display"
    t.string   "screenwriter_display"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "movies", ["year_id", "title_index"], name: "index_movies_on_year_id_and_title_index", using: :btree

  create_table "people", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["last_name"], name: "index_users_on_last_name", using: :btree

  create_table "votes", force: true do |t|
    t.integer  "ballot_id"
    t.integer  "category_id"
    t.integer  "credit_id"
    t.integer  "movie_id"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["ballot_id", "category_id"], name: "index_votes_on_ballot_id_and_category_id", using: :btree
  add_index "votes", ["category_id"], name: "index_votes_on_category_id", using: :btree
  add_index "votes", ["credit_id"], name: "index_votes_on_credit_id", using: :btree

  create_table "years", force: true do |t|
    t.string   "name"
    t.datetime "open_voting",     default: '2001-01-01 00:00:00'
    t.datetime "close_voting",    default: '2001-01-01 00:00:00'
    t.datetime "display_results", default: '2001-01-01 00:00:00'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
