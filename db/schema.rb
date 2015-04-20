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

ActiveRecord::Schema.define(version: 20150419193218) do

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.string   "category"
    t.string   "short_text"
    t.string   "long_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.string   "short_text"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "registration"
    t.integer  "place_number"
    t.integer  "admin_id"
  end

  add_index "events", ["admin_id"], name: "index_events_on_admin_id"

  create_table "form_answers", force: :cascade do |t|
    t.string  "answer"
    t.integer "event_id"
    t.integer "form_element_id"
    t.integer "participant_id"
  end

  add_index "form_answers", ["event_id"], name: "index_form_answers_on_event_id"
  add_index "form_answers", ["form_element_id"], name: "index_form_answers_on_form_element_id"
  add_index "form_answers", ["participant_id"], name: "index_form_answers_on_participant_id"

  create_table "form_elements", force: :cascade do |t|
    t.string  "question"
    t.integer "form_type"
    t.text    "data"
    t.integer "event_id"
  end

  add_index "form_elements", ["event_id"], name: "index_form_elements_on_event_id"

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.string   "category"
    t.integer  "priority"
    t.string   "author"
    t.string   "short_text"
    t.text     "long_text"
    t.string   "version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  create_table "reviewpropositions", force: :cascade do |t|
    t.string   "file"
    t.text     "lecturer_info"
    t.text     "validator_comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_name"
    t.integer  "review_id"
  end

  add_index "reviewpropositions", ["review_id"], name: "index_reviewpropositions_on_review_id"

  create_table "reviews", force: :cascade do |t|
    t.string   "name"
    t.text     "general_info"
    t.integer  "state",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "validator_id"
    t.integer  "lecturer_id"
  end

  add_index "reviews", ["lecturer_id"], name: "index_reviews_on_lecturer_id"
  add_index "reviews", ["validator_id"], name: "index_reviews_on_validator_id"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password"
    t.string   "phone"
    t.string   "address"
    t.integer  "role"
    t.integer  "diet"
    t.string   "nationality"
    t.string   "title"
    t.integer  "sex"
    t.boolean  "has_paid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "birth"
    t.string   "token"
  end

  create_table "users_events", id: false, force: :cascade do |t|
    t.integer "event_id"
    t.integer "user_id"
  end

  add_index "users_events", ["event_id"], name: "index_users_events_on_event_id"
  add_index "users_events", ["user_id"], name: "index_users_events_on_user_id"

end
