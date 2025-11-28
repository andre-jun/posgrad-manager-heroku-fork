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

ActiveRecord::Schema[8.1].define(version: 2025_11_26_221019) do
  create_table "administrators", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_administrators_on_user_id"
  end

  create_table "contact_infos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "phone_number"
    t.string "room_number"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_contact_infos_on_user_id"
  end

  create_table "professor_mentors_students", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "professor_id", null: false
    t.integer "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["professor_id", "student_id"], name: "idx_on_professor_id_student_id_e35ecf3a04", unique: true
  end

  create_table "professors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "department"
    t.string "research_area"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_professors_on_user_id"
  end

  create_table "publications", force: :cascade do |t|
    t.string "abstract"
    t.datetime "created_at", null: false
    t.string "link"
    t.integer "professor_id"
    t.date "publication_date"
    t.integer "student_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["professor_id"], name: "index_publications_on_professor_id"
    t.index ["student_id"], name: "index_publications_on_student_id"
  end

  create_table "report_field_answers", force: :cascade do |t|
    t.string "answer"
    t.datetime "created_at", null: false
    t.integer "report_field_id", null: false
    t.integer "report_info_id", null: false
    t.datetime "updated_at", null: false
    t.index ["report_field_id"], name: "index_report_field_answers_on_report_field_id"
    t.index ["report_info_id"], name: "index_report_field_answers_on_report_info_id"
  end

  create_table "report_fields", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "field_type", default: "Text"
    t.string "options"
    t.string "question", null: false
    t.integer "report_id", null: false
    t.boolean "required", default: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_report_fields_on_report_id"
  end

  create_table "report_infos", force: :cascade do |t|
    t.string "coordinator_comments"
    t.datetime "created_at", null: false
    t.date "date_sent"
    t.string "owner", default: "Student"
    t.string "professor_comments"
    t.integer "report_id", null: false
    t.string "review_administrator", default: "Pendente"
    t.datetime "review_date"
    t.string "review_professor", default: "Pendente"
    t.integer "reviewer_id"
    t.string "status", default: "Draft"
    t.integer "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id", "student_id"], name: "index_report_infos_on_report_id_and_student_id", unique: true
    t.index ["report_id"], name: "index_report_infos_on_report_id"
    t.index ["student_id"], name: "index_report_infos_on_student_id"
  end

  create_table "reports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "due_date_administrator"
    t.date "due_date_professor"
    t.date "due_date_student"
    t.string "owner", default: "Student"
    t.integer "semester"
    t.datetime "updated_at", null: false
    t.integer "year"
  end

  create_table "students", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "credits", default: 0
    t.integer "credits_needed", default: 0
    t.date "join_date"
    t.date "lattes_last_update"
    t.string "lattes_link"
    t.string "pretended_career"
    t.string "program_level"
    t.integer "semester", default: 0
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_students_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email"
    t.string "encrypted_password"
    t.boolean "first_login", default: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "login_id"
    t.string "name"
    t.string "nusp"
    t.string "pronoun"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.string "status", default: "Ativo"
    t.string "surname"
    t.datetime "updated_at", null: false
    t.index ["login_id"], name: "index_users_on_login_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "administrators", "users"
  add_foreign_key "contact_infos", "users"
  add_foreign_key "professors", "users"
  add_foreign_key "publications", "professors"
  add_foreign_key "publications", "students"
  add_foreign_key "report_field_answers", "report_fields"
  add_foreign_key "report_field_answers", "report_infos"
  add_foreign_key "report_fields", "reports"
  add_foreign_key "report_infos", "professors", column: "reviewer_id"
  add_foreign_key "report_infos", "reports"
  add_foreign_key "report_infos", "students"
  add_foreign_key "students", "users"
end
