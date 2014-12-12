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

ActiveRecord::Schema.define(version: 20140727175146) do

  create_table "categories", force: true do |t|
    t.integer  "cat_type",       default: 0, null: false
    t.string   "name",                       null: false
    t.datetime "last_published"
  end

  add_index "categories", ["cat_type", "name"], name: "index_categories_on_cat_type_and_name", unique: true

  create_table "categorisations", force: true do |t|
    t.integer  "video_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categorisations", ["video_id", "category_id"], name: "index_categorisations_on_video_id_and_category_id", unique: true

  create_table "channels", force: true do |t|
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "alias"
    t.string   "user_id"
  end

  add_index "channels", ["updated_at"], name: "index_channels_on_updated_at"
  add_index "channels", ["username"], name: "index_channels_on_username", unique: true

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
    t.integer  "role",                   default: 0,  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "videos", force: true do |t|
    t.string   "title"
    t.string   "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "channel_id"
    t.datetime "published_at", null: false
  end

  add_index "videos", ["published_at"], name: "index_videos_on_published_at"
  add_index "videos", ["video_id"], name: "index_videos_on_video_id", unique: true

  create_table "youtube_auths", force: true do |t|
    t.integer  "singleton_guard", default: 0
    t.string   "access_token"
    t.string   "refresh_token"
    t.string   "client_id"
    t.string   "client_secret"
    t.string   "dev_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "youtube_auths", ["singleton_guard"], name: "index_youtube_auths_on_singleton_guard", unique: true

end
