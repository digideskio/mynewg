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

ActiveRecord::Schema.define(version: 20151210082844) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "appointments", force: :cascade do |t|
    t.datetime "scheduled_time"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "attachments", force: :cascade do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type", limit: 255
    t.string   "file",            limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "billing_notifications", force: :cascade do |t|
    t.datetime "billing_date"
    t.integer  "user_id"
    t.integer  "package_price_id"
    t.integer  "status",           default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "chats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discount_code_packages", force: :cascade do |t|
    t.integer  "discount_code_id"
    t.integer  "package_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "discount_code_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "discount_code_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "status",           default: 0
  end

  create_table "discount_codes", force: :cascade do |t|
    t.string   "code"
    t.integer  "gender"
    t.decimal  "value"
    t.integer  "discount_type"
    t.integer  "price_type"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "public",        default: true
  end

  create_table "event_attendees", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "attendee_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "checked_in",  default: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "location",           limit: 255
    t.text     "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.boolean  "matched",                        default: false
    t.integer  "max_attendees",                  default: 1
    t.integer  "count_of_attendees",             default: 0
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "like_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "likes", ["user_id", "like_id"], name: "index_likes_on_user_id_and_like_id", unique: true, using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "chat_id"
    t.integer  "user_id"
    t.string   "text",       limit: 255
    t.integer  "state",                  default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "category"
    t.integer  "event_id"
    t.integer  "source_id"
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "state",      default: 0
    t.string   "text"
    t.integer  "status",     default: 0
  end

  create_table "package_events", force: :cascade do |t|
    t.integer  "package_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "package_price_commissions", force: :cascade do |t|
    t.integer  "role"
    t.decimal  "value",            precision: 10, default: 0
    t.integer  "package_price_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "status",                          default: 0
  end

  create_table "package_prices", force: :cascade do |t|
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "package_id"
    t.integer  "interval",                  default: 0
    t.integer  "gender"
    t.decimal  "value",      precision: 10, default: 0
    t.integer  "status",                    default: 0
  end

  create_table "packages", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "status",                  default: 0
    t.integer  "tier"
    t.text     "description"
    t.integer  "chat_status",             default: 0
  end

  create_table "participants", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "chat_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.datetime "display_messages_from"
  end

  create_table "representative_codes", force: :cascade do |t|
    t.string   "value",             limit: 255
    t.integer  "status",                        default: 0
    t.integer  "representative_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "member_id"
    t.string   "gender"
    t.integer  "scratch_barcode"
    t.boolean  "multi",                         default: false
  end

  create_table "sale_transaction_commissions", force: :cascade do |t|
    t.integer  "sale_transaction_id"
    t.integer  "package_price_commission_id"
    t.integer  "status",                      default: 0
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "representative_id"
    t.integer  "payment_type"
  end

  create_table "sale_transactions", force: :cascade do |t|
    t.decimal  "price",                                 precision: 10
    t.integer  "member_id"
    t.integer  "primary_representative_id"
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
    t.integer  "package_price_id"
    t.string   "omise_charge_id",           limit: 255
    t.integer  "payment_type"
    t.integer  "status",                                               default: 0
    t.string   "discount_code"
  end

  create_table "searches", force: :cascade do |t|
    t.string   "query"
    t.datetime "searched_at"
    t.datetime "converted_at"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "user_blocks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "blocked_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_favourites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "favourite_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "user_favourites", ["user_id", "favourite_id"], name: "index_user_favourites_on_user_id_and_favourite_id", unique: true, using: :btree

  create_table "user_flags", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "flagged_id"
    t.integer  "reason"
    t.text     "additional_info"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "user_managers", force: :cascade do |t|
    t.integer  "junior_id"
    t.integer  "senior_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                     limit: 255, default: "",      null: false
    t.string   "encrypted_password",        limit: 255, default: "",      null: false
    t.string   "reset_password_token",      limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",        limit: 255
    t.string   "last_sign_in_ip",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                      limit: 255
    t.integer  "role",                                  default: 0
    t.integer  "package_id"
    t.integer  "gender",                                default: 0
    t.string   "sales_code",                limit: 255
    t.string   "username",                  limit: 255
    t.string   "omise_id",                  limit: 255
    t.integer  "status",                                default: 0
    t.string   "provider",                  limit: 255,                   null: false
    t.string   "uid",                       limit: 255, default: "",      null: false
    t.text     "tokens"
    t.datetime "date_of_birth"
    t.string   "profile_video_url"
    t.string   "location"
    t.string   "phone",                                 default: "0"
    t.string   "line_id"
    t.integer  "age",                                   default: 0
    t.integer  "drink",                                 default: 0
    t.integer  "english",                               default: 0
    t.integer  "height",                                default: 160
    t.boolean  "kids",                                  default: false
    t.integer  "smoke",                                 default: 0
    t.integer  "thai",                                  default: 0
    t.boolean  "visible",                               default: true
    t.string   "biography"
    t.datetime "deleted_at"
    t.boolean  "platinum",                              default: false
    t.boolean  "paid_by_cash",                          default: false
    t.float    "cash_amount",                           default: 0.0
    t.boolean  "waive_join_fee",                        default: false
    t.integer  "count_of_attending_events",             default: 0
    t.string   "facebook_id"
    t.string   "locale",                                default: "en_US"
    t.string   "display_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

end
