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

ActiveRecord::Schema.define(version: 20130716205835) do

  create_table "agents", force: true do |t|
    t.string   "tenant_id"
    t.boolean  "available"
    t.boolean  "engaged"
    t.string   "display_name"
    t.string   "encrypted_password"
    t.string   "xid"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversations", force: true do |t|
    t.string   "tenant_id"
    t.boolean  "active"
    t.string   "customer_id"
    t.string   "referer_url"
    t.string   "location"
    t.string   "customer_data"
    t.integer  "first_customer_message"
    t.integer  "engaged_agent"
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

  create_table "tenants", force: true do |t|
    t.string   "twitter_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
