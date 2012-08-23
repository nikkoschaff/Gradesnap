class CoursesStudents < ActiveRecord::Base
  attr_accessible :course_id, :student_id

  belongs_to :courses
  belongs_to :students

  validates :course_id, :presence => true
  validates :student_id, :presence => true
end
