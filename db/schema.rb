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

ActiveRecord::Schema.define(version: 20150704033708) do

  create_table "book_numbers", force: true do |t|
    t.string   "kbn"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "book_numbers", ["kbn"], name: "index_book_numbers_on_kbn", using: :btree

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
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "male",        default: false
    t.string   "suffix"
    t.string   "birth_day"
    t.string   "birth_place"
    t.string   "death_day"
    t.string   "death_place"
  end

  add_index "people", ["first_name"], name: "index_people_on_first_name", using: :btree
  add_index "people", ["last_name"], name: "index_people_on_last_name", using: :btree
  add_index "people", ["male"], name: "index_people_on_male", using: :btree

  create_table "people_book_numbers", force: true do |t|
    t.integer  "book_number_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people_book_numbers", ["book_number_id"], name: "index_people_book_numbers_on_book_number_id", using: :btree
  add_index "people_book_numbers", ["person_id"], name: "index_people_book_numbers_on_person_id", using: :btree

  create_table "relationship_people", force: true do |t|
    t.integer  "relationship_id"
    t.integer  "person_id"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  add_index "relationship_people", ["order"], name: "index_relationship_people_on_order", using: :btree
  add_index "relationship_people", ["person_id"], name: "index_relationship_people_on_person_id", using: :btree
  add_index "relationship_people", ["relationship_id"], name: "index_relationship_people_on_relationship_id", using: :btree
  add_index "relationship_people", ["type"], name: "index_relationship_people_on_type", using: :btree

  create_table "relationships", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "marriage_day"
    t.string   "divorce_day"
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
