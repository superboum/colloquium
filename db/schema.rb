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

ActiveRecord::Schema.define(version: 20150301162556) do

  create_table "articles", force: true do |t|
    t.string   "title"
    t.string   "category"
    t.string   "short_text"
    t.string   "long_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "title"
    t.string   "short_text"
    t.datetime "begin"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.string   "title"
    t.string   "category"
    t.integer  "priority"
    t.string   "author"
    t.string   "short_text"
    t.text     "long_text"
    t.string   "version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
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
  end

end
