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

ActiveRecord::Schema.define(version: 20161130092756) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.boolean  "checked",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "appointments", force: :cascade do |t|
    t.integer  "mentee_id"
    t.integer  "mentor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time     "started_at"
    t.time     "duration"
    t.boolean  "finished"
  end

  add_index "appointments", ["mentee_id"], name: "index_appointments_on_mentee_id", using: :btree
  add_index "appointments", ["mentor_id"], name: "index_appointments_on_mentor_id", using: :btree

  create_table "bootsy_image_galleries", force: :cascade do |t|
    t.integer  "bootsy_resource_id"
    t.string   "bootsy_resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: :cascade do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "story_id"
    t.integer  "post_status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "content_id"
  end

  create_table "contents", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "cached_votes_up",    default: 0
    t.integer  "cached_votes_down",  default: 0
    t.integer  "cached_votes_score", default: 0
    t.integer  "shares_count",       default: 0
    t.datetime "publishing_at"
    t.integer  "comments_count",     default: 0
    t.tsvector "tsv"
  end

  add_index "contents", ["cached_votes_down"], name: "index_contents_on_cached_votes_down", using: :btree
  add_index "contents", ["cached_votes_score"], name: "index_contents_on_cached_votes_score", using: :btree
  add_index "contents", ["cached_votes_up"], name: "index_contents_on_cached_votes_up", using: :btree
  add_index "contents", ["description"], name: "contents_on_description_idx", using: :gin
  add_index "contents", ["title"], name: "index_contents_on_title", using: :btree
  add_index "contents", ["tsv"], name: "index_contents_on_tsv", using: :gin

  create_table "contents_hash_tags", id: false, force: :cascade do |t|
    t.integer "hash_tag_id"
    t.integer "content_id"
  end

  add_index "contents_hash_tags", ["content_id"], name: "index_contents_hash_tags_on_content_id", using: :btree
  add_index "contents_hash_tags", ["hash_tag_id", "content_id"], name: "index_contents_hash_tags_on_hash_tag_id_and_content_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.integer  "participants",   default: [],              array: true
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "appointment_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  add_index "delayed_jobs", ["queue"], name: "delayed_jobs_queue", using: :btree

  create_table "feedbacks", force: :cascade do |t|
    t.string   "subject"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "checked",     default: false
  end

  add_index "feedbacks", ["checked"], name: "index_feedbacks_on_checked", using: :btree
  add_index "feedbacks", ["user_id"], name: "index_feedbacks_on_user_id", using: :btree

  create_table "hash_tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "mentor_id"
  end

  add_index "hash_tags", ["name"], name: "index_hash_tags_on_name", using: :btree

  create_table "hash_tags_users", id: false, force: :cascade do |t|
    t.integer "hash_tag_id"
    t.integer "user_id"
  end

  add_index "hash_tags_users", ["hash_tag_id", "user_id"], name: "index_hash_tags_users_on_hash_tag_id_and_user_id", using: :btree
  add_index "hash_tags_users", ["user_id"], name: "index_hash_tags_users_on_user_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.string  "uid"
    t.string  "provider"
    t.integer "user_id"
    t.string  "oauth_token"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "mentorships", force: :cascade do |t|
    t.integer  "mentor_id"
    t.integer  "hash_tag_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "mentorships", ["hash_tag_id"], name: "index_mentorships_on_hash_tag_id", using: :btree
  add_index "mentorships", ["mentor_id"], name: "index_mentorships_on_mentor_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "subject"
    t.text     "body"
    t.integer  "receiver_id"
    t.integer  "sender_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_read",         default: false
    t.boolean  "removed",         default: false
    t.datetime "removed_at"
    t.integer  "conversation_id"
    t.boolean  "daily_message",   default: false
    t.integer  "story_id"
  end

  create_table "mobile_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "device_token"
    t.string   "fcm_token"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "mobile_tokens", ["user_id"], name: "index_mobile_tokens_on_user_id", using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "phone_number_invitations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phone_number_invitations", ["phone_number"], name: "index_phone_number_invitations_on_phone_number", using: :btree

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "reports", force: :cascade do |t|
    t.text     "description"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "target_type"
    t.boolean  "reviewed",    default: false
    t.integer  "user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shares", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                default: "",    null: false
    t.string   "encrypted_password",                   default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "location"
    t.text     "biography"
    t.integer  "sex"
    t.string   "country"
    t.date     "birthdate"
    t.string   "nick"
    t.boolean  "is_newbie",                            default: true
    t.boolean  "receive_notification",                 default: true
    t.boolean  "receive_messages_only_from_followers", default: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "password_confirmations"
    t.integer  "role_id"
    t.datetime "notifications_checked_at"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.string   "phone_number"
    t.tsvector "tsv"
    t.datetime "last_seen"
  end

  add_index "users", ["first_name"], name: "index_users_on_first_name", using: :btree
  add_index "users", ["last_name"], name: "index_users_on_last_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree
  add_index "users", ["tsv"], name: "index_users_on_tsv", using: :gin

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

  create_table "words", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "mobile_tokens", "users"
  add_foreign_key "users", "roles"
end
