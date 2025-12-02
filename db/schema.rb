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

ActiveRecord::Schema[7.1].define(version: 2025_12_02_161234) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calendriers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medicaments", force: :cascade do |t|
    t.string "nom"
    t.string "format"
    t.boolean "ordonnance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "prise", default: [], array: true
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

  add_foreign_key "pillatheque_medicaments", "medicaments"
  add_foreign_key "pillatheque_medicaments", "pillatheques"
  add_foreign_key "pillatheques", "users"
end
