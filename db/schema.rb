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

ActiveRecord::Schema.define(version: 20130801222756) do

  create_table "agents", force: true do |t|
    t.string   "tenant_id",                              null: false
    t.string   "email",                                  null: false
    t.string   "encrypted_password",                     null: false
    t.string   "display_name",                           null: false
    t.integer  "available",              default: 0,     null: false
    t.boolean  "engaged",                default: false, null: false
    t.boolean  "admin",                  default: false, null: false
    t.string   "xid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "agents", ["confirmation_token"], name: "index_agents_on_confirmation_token", unique: true, using: :btree
  add_index "agents", ["email"], name: "index_agents_on_email", unique: true, using: :btree
  add_index "agents", ["reset_password_token"], name: "index_agents_on_reset_password_token", unique: true, using: :btree

  create_table "conversations", force: true do |t|
    t.string   "tenant_id"
    t.boolean  "active"
    t.string   "customer_id"
    t.string   "referer_url"
    t.string   "location"
    t.string   "customer_data"
    t.integer  "first_customer_message"
    t.integer  "target_agent_id"
    t.integer  "engaged_agent_id"
    t.string   "preferred_response_channel"
    t.string   "preferred_response_channel_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.string   "tenant_id"
    t.string   "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invites", force: true do |t|
    t.string   "tenant_id"
    t.string   "recipient_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.string   "tenant_id"
    t.string   "conversation_id"
    t.string   "agent_id"
    t.string   "sent_by"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["agent_id"], name: "index_messages_on_agent_id", using: :btree
  add_index "messages", ["conversation_id", "updated_at"], name: "index_messages_on_conversation_id_and_updated_at", using: :btree
  add_index "messages", ["updated_at"], name: "index_messages_on_updated_at", using: :btree

  create_table "tenants", force: true do |t|
    t.string   "display_name"
    t.string   "twitter_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
