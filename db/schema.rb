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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120711155641) do

  create_table "assignment_students", :force => true do |t|
    t.integer  "assignment_id"
    t.integer  "student_id"
    t.integer  "scansheet_id"
    t.float    "grade"
    t.string   "results"
    t.string   "answer_key"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "assignment_students", ["assignment_id", "student_id"], :name => "index_assignment_students_on_assignment_id_and_student_id", :unique => true
  add_index "assignment_students", ["assignment_id"], :name => "index_assignment_students_on_assignment_id"
  add_index "assignment_students", ["student_id"], :name => "index_assignment_students_on_student_id"

  create_table "assignments", :force => true do |t|
    t.integer  "num_questions"
    t.string   "answer_key"
    t.string   "name"
    t.string   "answer_scansheet"
    t.string   "email"
    t.integer  "course_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "course_students", :force => true do |t|
    t.integer  "course_id"
    t.integer  "student_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "course_students", ["course_id", "student_id"], :name => "index_course_students_on_course_id_and_student_id", :unique => true
  add_index "course_students", ["course_id"], :name => "index_course_students_on_course_id"
  add_index "course_students", ["student_id"], :name => "index_course_students_on_student_id"

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.integer  "teacher_id"
    t.datetime "updated_at", :null => false
  end

  create_table "excelsheets", :force => true do |t|
    t.string   "datafile"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "issues", :force => true do |t|
    t.integer  "code"
    t.integer  "teacher_id"
    t.string   "tablename"
    t.integer  "row_id"
    t.boolean  "resolved"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "scansheets", :force => true do |t|
    t.string   "name"
    t.string   "ambiguous_answers"
    t.string   "answers_string"
    t.string   "assignment_student_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "assignment_id"
    t.string   "image"
  end

  create_table "students", :force => true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.integer  "course_id"
    t.float    "grade"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "teachers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "email"
    t.string   "salt"
    t.datetime "created_at"
    t.integer  "teacher_id"
  end

end
