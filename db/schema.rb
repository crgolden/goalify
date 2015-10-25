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

ActiveRecord::Schema.define(version: 20151023003428) do

  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'
  enable_extension 'uuid-ossp'

  create_table 'comments', id: :uuid, default: 'uuid_generate_v4()', force: :cascade do |t|
    t.uuid 'goal_id'
    t.uuid 'user_id'
    t.text 'body'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'goals', id: :uuid, default: 'uuid_generate_v4()', force: :cascade do |t|
    t.uuid 'user_id'
    t.integer 'score', default: 0, null: false
    t.string 'title'
    t.text 'text'
    t.integer 'parent_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_index 'goals', ['parent_id'], name: 'index_goals_on_parent_id', using: :btree

  create_table 'pg_search_documents', force: :cascade do |t|
    t.text 'content'
    t.integer 'searchable_id'
    t.string 'searchable_type'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_index 'pg_search_documents', ['searchable_type', 'searchable_id'], name: 'index_pg_search_documents_on_searchable_type_and_searchable_id', using: :btree

  create_table 'scores', id: :uuid, default: 'uuid_generate_v4()', force: :cascade do |t|
    t.uuid 'subscription_id'
    t.integer 'value', default: 0
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'subscriptions', id: :uuid, default: 'uuid_generate_v4()', force: :cascade do |t|
    t.uuid 'user_id'
    t.uuid 'goal_id'
    t.boolean 'completed', default: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'tokens', id: :uuid, default: 'uuid_generate_v4()', force: :cascade do |t|
    t.uuid 'user_id'
    t.string 'access_token'
    t.string 'refresh_token'
    t.string 'provider'
    t.string 'uid'
    t.string 'image'
    t.datetime 'expires_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_index 'tokens', ['provider'], name: 'index_users_on_provider', using: :btree
  add_index 'tokens', ['uid'], name: 'index_users_on_uid', using: :btree

  create_table 'users', id: :uuid, default: 'uuid_generate_v4()', force: :cascade do |t|
    t.integer 'score', default: 0, null: false
    t.integer 'role', default: 0, null: false
    t.integer 'status', default: 0, null: false
    t.string 'email', default: '', null: false
    t.string 'name'
    t.string 'authentication_token'
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.inet 'current_sign_in_ip'
    t.inet 'last_sign_in_ip'
    t.string 'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string 'unconfirmed_email'
    t.integer 'failed_attempts', default: 0, null: false
    t.string 'unlock_token'
    t.datetime 'locked_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_index 'users', ['authentication_token'], name: 'index_users_on_authentication_token', unique: true, using: :btree
  add_index 'users', ['confirmation_token'], name: 'index_users_on_confirmation_token', unique: true, using: :btree
  add_index 'users', ['email'], name: 'index_users_on_email', unique: true, using: :btree
  add_index 'users', ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true, using: :btree
  add_index 'users', ['unlock_token'], name: 'index_users_on_unlock_token', unique: true, using: :btree

  add_foreign_key 'comments', 'goals'
  add_foreign_key 'comments', 'users'
  add_foreign_key 'goals', 'users'
  add_foreign_key 'scores', 'subscriptions'
  add_foreign_key 'subscriptions', 'goals'
  add_foreign_key 'subscriptions', 'users'
  add_foreign_key 'tokens', 'users'
end
