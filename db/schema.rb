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

ActiveRecord::Schema.define(version: 20151208202354) do

  create_table "posts", force: :cascade do |t|
    t.text     "text",              limit: 65535
    t.string   "short_text",        limit: 255
    t.integer  "facebook_post_id",  limit: 4
    t.integer  "twitter_post_id",   limit: 4
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.text     "ending_text",       limit: 65535
    t.string   "short_ending_text", limit: 255
  end

  create_table "posts_routes", force: :cascade do |t|
    t.integer  "post_id",    limit: 4
    t.integer  "route_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routes", force: :cascade do |t|
    t.string "name",     limit: 255
    t.string "number",   limit: 255
    t.string "property", limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", limit: 255
    t.string "last_name",  limit: 255
    t.string "spire",      limit: 255
    t.string "email",      limit: 255
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255,        null: false
    t.integer  "item_id",    limit: 4,          null: false
    t.string   "event",      limit: 255,        null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object",     limit: 4294967295
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
