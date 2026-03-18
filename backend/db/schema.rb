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

ActiveRecord::Schema[7.2].define(version: 2026_03_17_132252) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "appointments", force: :cascade do |t|
    t.bigint "guest_id", null: false
    t.bigint "catalog_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "scheduled_at", null: false
    t.string "created_by", default: "SYSTEM", null: false
    t.string "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["catalog_id"], name: "index_appointments_on_catalog_id"
    t.index ["guest_id"], name: "index_appointments_on_guest_id"
    t.index ["scheduled_at"], name: "index_appointments_on_scheduled_at"
    t.index ["status"], name: "index_appointments_on_status"
  end

  create_table "catalogs", force: :cascade do |t|
    t.bigint "nutritionist_id", null: false
    t.bigint "service_id", null: false
    t.bigint "district_id"
    t.decimal "price", precision: 5, scale: 2, null: false
    t.string "address", limit: 300
    t.integer "duration", null: false
    t.string "created_by", default: "SYSTEM", null: false
    t.string "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["district_id"], name: "index_catalogs_on_district_id"
    t.index ["nutritionist_id", "service_id", "district_id"], name: "idx_on_nutritionist_id_service_id_district_id_599c105fab", unique: true
    t.index ["nutritionist_id"], name: "index_catalogs_on_nutritionist_id"
    t.index ["service_id"], name: "index_catalogs_on_service_id"
  end

  create_table "districts", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "code", limit: 50, null: false
    t.string "language", limit: 2, default: "pt", null: false
    t.string "created_by", default: "SYSTEM", null: false
    t.string "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_districts_on_code", unique: true
  end

  create_table "guests", force: :cascade do |t|
    t.string "first_name", limit: 30, null: false
    t.string "last_name", limit: 30, null: false
    t.string "email", limit: 100, null: false
    t.string "created_by", default: "SYSTEM", null: false
    t.string "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_guests_on_email", unique: true
    t.index ["first_name", "last_name"], name: "index_guests_on_first_name_and_last_name"
  end

  create_table "nutritionists", force: :cascade do |t|
    t.string "first_name", limit: 30, null: false
    t.string "last_name", limit: 30, null: false
    t.string "email", limit: 100, null: false
    t.string "professional_id", limit: 20, null: false
    t.string "created_by", default: "SYSTEM", null: false
    t.string "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_nutritionists_on_email", unique: true
    t.index ["first_name", "last_name"], name: "index_nutritionists_on_first_name_and_last_name"
    t.index ["professional_id"], name: "index_nutritionists_on_professional_id", unique: true
  end

  create_table "services", force: :cascade do |t|
    t.string "code", limit: 30, null: false
    t.string "service_type", limit: 30, null: false
    t.string "description", limit: 100, null: false
    t.string "created_by", default: "SYSTEM", null: false
    t.string "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code", "service_type"], name: "index_services_on_code_and_service_type", unique: true
  end

  add_foreign_key "appointments", "catalogs"
  add_foreign_key "appointments", "guests"
  add_foreign_key "catalogs", "districts"
  add_foreign_key "catalogs", "nutritionists"
  add_foreign_key "catalogs", "services"
end
