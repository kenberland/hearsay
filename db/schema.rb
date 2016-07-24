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

ActiveRecord::Schema.define(version: 20160724072949) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "tag_categories", force: :cascade do |t|
    t.string   "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tag_categories", ["category"], name: "index_tag_categories_on_category", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "tag",             null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "tag_category_id"
    t.boolean  "is_library_tag"
  end

  add_index "tags", ["is_library_tag"], name: "index_is_library_tag_on_tags", using: :btree
  add_index "tags", ["tag", "tag_category_id"], name: "index_tags_on_tag_and_tag_category_id", unique: true, using: :btree
  add_index "tags", ["tag_category_id"], name: "index_tags_on_tag_category_id", using: :btree

  create_table "user_tags", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "from_user_uid", limit: 8, null: false
    t.integer  "to_user_uid",   limit: 8, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "user_tags", ["from_user_uid", "to_user_uid", "tag_id"], name: "index_user_tags_unique_on_to_from_tag", unique: true, using: :btree
  add_index "user_tags", ["from_user_uid"], name: "index_user_tags_on_from_user_uid", using: :btree
  add_index "user_tags", ["tag_id"], name: "index_user_tags_on_tag_id", using: :btree
  add_index "user_tags", ["to_user_uid"], name: "index_user_tags_on_to_user_uid", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "uid",          limit: 8,   null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "location",     limit: 255
    t.string   "phone_number", limit: 255
  end

  add_foreign_key "tags", "tag_categories"
  add_foreign_key "user_tags", "tags"
end
