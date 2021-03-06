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

ActiveRecord::Schema.define(version: 20120808164543) do

  create_table "assignments", force: true do |t|
    t.integer  "num_questions"
    t.text     "answer_key"
    t.text     "name"
    t.text     "answer_scansheet"
    t.text     "email"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments_students", force: true do |t|
    t.integer  "assignment_id"
    t.integer  "student_id"
    t.integer  "scansheet_id"
    t.float    "grade"
    t.text     "results"
    t.text     "answer_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments_students", ["assignment_id", "student_id"], name: "index_assignments_students_on_assignment_id_and_student_id", unique: true
  add_index "assignments_students", ["assignment_id"], name: "index_assignments_students_on_assignment_id"
  add_index "assignments_students", ["student_id"], name: "index_assignments_students_on_student_id"

  create_table "contacts", force: true do |t|
    t.string   "email"
    t.string   "subject"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.integer  "teacher_id"
    t.datetime "updated_at"
  end

  create_table "courses_students", force: true do |t|
    t.integer  "course_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "courses_students", ["course_id", "student_id"], name: "index_courses_students_on_course_id_and_student_id", unique: true
  add_index "courses_students", ["course_id"], name: "index_courses_students_on_course_id"
  add_index "courses_students", ["student_id"], name: "index_courses_students_on_student_id"

  create_table "exportsheets", force: true do |t|
    t.string   "student"
    t.integer  "grade"
    t.integer  "assignment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "importsheets", force: true do |t|
    t.string   "datafile"
    t.string   "name"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "issues", force: true do |t|
    t.integer  "code"
    t.integer  "teacher_id"
    t.integer  "scansheet_id"
    t.boolean  "resolved"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scansheets", force: true do |t|
    t.text     "name"
    t.text     "ambiguous_answers"
    t.text     "answers_string"
    t.text     "assignment_student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assignment_id"
    t.string   "image"
  end

  create_table "students", force: true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.integer  "course_id"
    t.float    "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teachers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "email"
    t.string   "salt"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
