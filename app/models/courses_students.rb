class CoursesStudents < ActiveRecord::Base
  attr_accessible :course_id, :student_id

  belongs_to :course, class_name: "Course"
  belongs_to :student, class_name: "Student"

  validates :course_id, :presence => true
  validates :student_id, :presence => true
end
