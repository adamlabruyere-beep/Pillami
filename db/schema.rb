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

ActiveRecord::Schema[7.1].define(version: 2025_12_05_142441) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "calendriers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.date "date"
    t.index ["user_id"], name: "index_calendriers_on_user_id"
  end

  create_table "entourage_members", force: :cascade do |t|
    t.bigint "entourage_id", null: false
    t.bigint "user_id", null: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entourage_id"], name: "index_entourage_members_on_entourage_id"
    t.index ["user_id"], name: "index_entourage_members_on_user_id"
  end

  create_table "entourages", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_entourages_on_user_id"
  end

  create_table "medicaments", force: :cascade do |t|
    t.string "nom"
    t.string "format"
    t.boolean "ordonnance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "prise", default: [], array: true
  end

  create_table "noticed_events", force: :cascade do |t|
    t.string "type"
    t.string "record_type"
    t.bigint "record_id"
    t.jsonb "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "notifications_count"
    t.index ["record_type", "record_id"], name: "index_noticed_events_on_record"
  end

  create_table "noticed_notifications", force: :cascade do |t|
    t.string "type"
    t.bigint "event_id", null: false
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.datetime "read_at", precision: nil
    t.datetime "seen_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_noticed_notifications_on_event_id"
    t.index ["recipient_type", "recipient_id"], name: "index_noticed_notifications_on_recipient"
  end

  create_table "pillatheque_medicaments", force: :cascade do |t|
    t.bigint "pillatheque_id", null: false
    t.bigint "medicament_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medicament_id"], name: "index_pillatheque_medicaments_on_medicament_id"
    t.index ["pillatheque_id"], name: "index_pillatheque_medicaments_on_pillatheque_id"
  end

  create_table "pillatheques", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_pillatheques_on_user_id"
  end

  create_table "reminders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "medicament_id", null: false
    t.string "message"
    t.text "days_of_week"
    t.time "time"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity"
    t.string "measure"
    t.integer "repeat_for_weeks"
    t.index ["medicament_id"], name: "index_reminders_on_medicament_id"
    t.index ["user_id"], name: "index_reminders_on_user_id"
  end

  create_table "sensations", force: :cascade do |t|
    t.text "content"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sensations_on_user_id"
  end

  create_table "solid_cable_messages", force: :cascade do |t|
    t.text "channel"
    t.text "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel"], name: "index_solid_cable_messages_on_channel"
    t.index ["created_at"], name: "index_solid_cable_messages_on_created_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "prenom"
    t.string "role"
    t.string "nom"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "calendriers", "users"
  add_foreign_key "entourage_members", "entourages"
  add_foreign_key "entourage_members", "users"
  add_foreign_key "entourages", "users"
  add_foreign_key "pillatheque_medicaments", "medicaments"
  add_foreign_key "pillatheque_medicaments", "pillatheques"
  add_foreign_key "pillatheques", "users"
  add_foreign_key "reminders", "medicaments"
  add_foreign_key "reminders", "users"
  add_foreign_key "sensations", "users"
end
