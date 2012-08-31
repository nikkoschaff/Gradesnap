class CreateCoursesStudents < ActiveRecord::Migration
  def change
    create_table :courses_students do |t|
      t.integer :course_id
      t.integer :student_id

      t.timestamps
    end

    add_index :courses_students, :course_id
    add_index :courses_students, :student_id
    add_index :courses_students, [:course_id, :student_id], unique: true
  end
end
