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

ActiveRecord::Schema.define(version: 20150815174734) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "images", force: true do |t|
    t.string   "type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "images", ["type"], name: "index_images_on_type", using: :btree

  create_table "people", force: true do |t|
    t.string   "first_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "male",               default: false
    t.string   "suffix"
    t.string   "birth_day"
    t.string   "birth_place"
    t.string   "death_day"
    t.string   "death_place"
    t.text     "relationship_ids",   default: [],    array: true
    t.text     "children_ids",       default: [],    array: true
    t.string   "pages",              default: [],    array: true
    t.string   "last_names",         default: [],    array: true
    t.string   "kbns",               default: [],    array: true
    t.string   "first_generation",   default: [],    array: true
    t.string   "second_generation",  default: [],    array: true
    t.string   "third_generation",   default: [],    array: true
    t.string   "fourth_generation",  default: [],    array: true
    t.string   "fifth_generation",   default: [],    array: true
    t.string   "sixth_generation",   default: [],    array: true
    t.string   "seventh_generation", default: [],    array: true
    t.string   "eighth_generation",  default: [],    array: true
    t.string   "primary_kbn"
  end

  add_index "people", ["first_name"], name: "index_people_on_first_name", using: :btree
  add_index "people", ["kbns"], name: "index_people_on_kbns", using: :btree
  add_index "people", ["last_names"], name: "index_people_on_last_names", using: :btree
  add_index "people", ["male"], name: "index_people_on_male", using: :btree
  add_index "people", ["primary_kbn"], name: "index_people_on_primary_kbn", using: :btree

  create_table "relationships", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "marriage_day"
    t.string   "divorce_day"
    t.text     "partner_ids",  default: [], array: true
    t.text     "children_ids", default: [], array: true
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["person_id"], name: "index_users_on_person_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
