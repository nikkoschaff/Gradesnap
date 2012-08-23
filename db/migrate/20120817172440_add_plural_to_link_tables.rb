class AddPluralToLinkTables < ActiveRecord::Migration
  def change
	#Change assignment_students to assignment_students
	rename_table :assignment_students, :assignments_students
	rename_index :assignment_students, :assignments_students, ["assignment_id", "student_id"]
	rename_index :assignment_students, :assignments_students, ["assignment_id"]
	rename_index :assignment_students, :assignments_students, ["student_id"]

	#Change course_students to courses_students
	rename_table :course_students, :courses_students
	rename_index :course_students, :courses_students, ["course_id", "student_id"]
	rename_index :course_students, :courses_students,  ["course_id"]
	rename_index :course_students, :courses_students,  ["student_id"]
  end
end
