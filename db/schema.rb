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

ActiveRecord::Schema.define(version: 20171212123921) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "name"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "role_id",                             null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  end

  create_table "dashboard_logs", force: :cascade do |t|
    t.text     "request_params"
    t.text     "response_params"
    t.string   "status_code"
    t.string   "mailchimp_list_type"
    t.string   "request_type"
    t.string   "filename"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "email"
    t.string   "opcode"
    t.string   "status"
    t.text     "error_message"
    t.text     "details"
  end

  create_table "mailchimp_new_accounts", force: :cascade do |t|
    t.string   "email"
    t.text     "data"
    t.string   "mailchimp_list_type"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "mailchimp_to_wv_operations", force: :cascade do |t|
    t.text     "data"
    t.string   "status"
    t.string   "action_name"
    t.string   "mailchimp_list_type"
    t.string   "wv_row_id"
    t.string   "email"
    t.string   "opcode"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "email_consent"
    t.text     "details"
    t.index ["email_consent", "opcode"], name: "index_mailchimp_to_wv_operations_on_email_consent_and_opcode", using: :btree
    t.index ["mailchimp_list_type", "action_name", "wv_row_id"], name: "mc_list_and_wv_row", using: :btree
    t.index ["status"], name: "index_mailchimp_to_wv_operations_on_status", using: :btree
    t.index ["updated_at"], name: "index_mailchimp_to_wv_operations_on_updated_at", using: :btree
  end

  create_table "mailchimp_unsubscribes", force: :cascade do |t|
    t.string   "email"
    t.string   "mailchimp_list_type"
    t.text     "data"
    t.text     "details"
    t.string   "status"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wv_to_mailchimp_operations", force: :cascade do |t|
    t.text     "data"
    t.string   "status"
    t.string   "mailchimp_list_type"
    t.string   "filename"
    t.string   "email"
    t.string   "opcode"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "email_consent"
    t.text     "details"
    t.index ["email_consent", "opcode"], name: "index_wv_to_mailchimp_operations_on_email_consent_and_opcode", using: :btree
    t.index ["mailchimp_list_type"], name: "index_wv_to_mailchimp_operations_on_mailchimp_list_type", using: :btree
    t.index ["status"], name: "index_wv_to_mailchimp_operations_on_status", using: :btree
    t.index ["updated_at"], name: "index_wv_to_mailchimp_operations_on_updated_at", using: :btree
  end

end
