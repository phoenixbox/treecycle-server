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

ActiveRecord::Schema.define(version: 20151130131152) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "citext"

  create_table "address_users", force: :cascade do |t|
    t.integer  "address_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "address_users", ["address_id"], name: "index_address_users_on_address_id", using: :btree
  add_index "address_users", ["user_id"], name: "index_address_users_on_user_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.string   "label",                                                    null: false
    t.decimal  "lat",                precision: 10, scale: 6
    t.decimal  "lng",                precision: 10, scale: 6
    t.integer  "type_cd",                                                  null: false
    t.jsonb    "address_components",                          default: {}, null: false
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
    t.string  "uid",                            null: false
    t.string  "display_name",                   null: false
    t.string  "email",                          null: false
    t.integer "authentication_id",              null: false
    t.string  "token",                          null: false
    t.jsonb   "raw",               default: {}, null: false
    t.text    "photo_url"
    t.jsonb   "name",              default: {}, null: false
  end

  add_index "facebook_profiles", ["raw"], name: "index_facebook_profiles_on_raw", using: :gin

  create_table "orders", force: :cascade do |t|
    t.string   "uuid",                        null: false
    t.integer  "status_cd"
    t.integer  "amount"
    t.integer  "address_id"
    t.integer  "phone_id"
    t.string   "currency"
    t.string   "charge_id"
    t.text     "description"
    t.boolean  "paid",        default: false, null: false
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "packages", force: :cascade do |t|
    t.integer "type_cd"
    t.integer "order_id"
    t.string  "size_value"
    t.string  "size_unit"
  end

  add_index "packages", ["order_id"], name: "index_packages_on_order_id", using: :btree
  add_index "packages", ["type_cd"], name: "index_packages_on_type_cd", using: :btree

  create_table "phone_users", force: :cascade do |t|
    t.integer  "phone_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "phone_users", ["phone_id"], name: "index_phone_users_on_phone_id", using: :btree
  add_index "phone_users", ["user_id"], name: "index_phone_users_on_user_id", using: :btree

  create_table "phones", force: :cascade do |t|
    t.string   "number",                       null: false
    t.string   "authy_id"
    t.string   "iso2"
    t.string   "calling_code"
    t.boolean  "verified",     default: false, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "phones", ["authy_id"], name: "index_phones_on_authy_id", unique: true, using: :btree

  create_table "pickup_dates", force: :cascade do |t|
    t.integer "order_id"
    t.integer "date",     limit: 8
  end

  add_index "pickup_dates", ["date"], name: "index_pickup_dates_on_date", using: :btree
  add_index "pickup_dates", ["order_id"], name: "index_pickup_dates_on_order_id", using: :btree

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
