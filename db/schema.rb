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

ActiveRecord::Schema.define(version: 2021_06_24_091715) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "check_domains", force: :cascade do |t|
    t.string "domain"
    t.string "markup"
    t.datetime "expire_at"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "check_expire_time_at"
    t.integer "project_id"
    t.string "status"
    t.datetime "latest_notice_at"
    t.jsonb "notice_info"
    t.index ["user_id"], name: "index_check_domains_on_user_id"
  end

  create_table "domain_msg_channels", force: :cascade do |t|
    t.bigint "check_domain_id", null: false
    t.bigint "msg_channel_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["check_domain_id"], name: "index_domain_msg_channels_on_check_domain_id"
    t.index ["msg_channel_id"], name: "index_domain_msg_channels_on_msg_channel_id"
  end

  create_table "msg_channels", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.string "type"
    t.string "markup"
    t.jsonb "config"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.boolean "is_common", default: true
    t.string "error_info"
    t.boolean "is_default", default: false
    t.index ["is_default"], name: "index_msg_channels_on_is_default"
    t.index ["user_id"], name: "index_msg_channels_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "check_domains_count"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "user_omniauths", force: :cascade do |t|
    t.string "nickname"
    t.string "provider", null: false
    t.string "uid"
    t.string "unionid"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider", "uid"], name: "index_user_omniauths_on_provider_and_uid"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.boolean "admin", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "api_token"
    t.index ["api_token"], name: "index_users_on_api_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "check_domains", "users"
  add_foreign_key "domain_msg_channels", "check_domains"
  add_foreign_key "domain_msg_channels", "msg_channels"
  add_foreign_key "msg_channels", "users"
end
