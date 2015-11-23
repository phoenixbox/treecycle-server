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

ActiveRecord::Schema.define(version: 20151123114628) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "citext"

  create_table "addresses", force: :cascade do |t|
    t.string   "label",                                                    null: false
    t.decimal  "lat",                precision: 10, scale: 6
    t.decimal  "lng",                precision: 10, scale: 6
    t.integer  "type_cd",                                                  null: false
    t.jsonb    "address_components",                          default: {}, null: false
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.text     "description"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
  end

  add_index "addresses", ["address_components"], name: "index_addresses_on_address_components", using: :gin
  add_index "addresses", ["type_cd"], name: "index_addresses_on_type_cd", using: :btree

  create_table "authentications", force: :cascade do |t|
    t.string   "uid",        null: false
    t.string   "provider",   null: false
    t.string   "token",      null: false
    t.string   "token_type", null: false
    t.integer  "user_id",    null: false
    t.integer  "expiration", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "facebook_profiles", force: :cascade do |t|
    t.string  "uid",               null: false
    t.string  "username"
    t.string  "display_name",      null: false
    t.string  "email",             null: false
    t.integer "authentication_id", null: false
    t.string  "token",             null: false
    t.hstore  "raw"
    t.text    "photo_url"
  end

  add_index "facebook_profiles", ["raw"], name: "index_facebook_profiles_on_raw", using: :gin

  create_table "phones", force: :cascade do |t|
    t.string   "number",                         null: false
    t.string   "authy_id"
    t.string   "iso2"
    t.string   "calling_code"
    t.boolean  "verified",       default: false, null: false
    t.integer  "phoneable_id"
    t.string   "phoneable_type"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "phones", ["authy_id"], name: "index_phones_on_authy_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "display_name"
    t.string   "uuid"
    t.string   "access_token"
    t.string   "roles",                  default: [], null: false, array: true
    t.string   "stripe_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["roles"], name: "index_users_on_roles", using: :gin

end
