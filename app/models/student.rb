class Student < ActiveRecord::Base
  attr_accessible :first_name,
		:middle_name,
		:last_name,
    :course_id,
    :grade

  #many-many connection with courses
  has_many :course_students, :foreign_key => "student_id"
  has_many :courses, :through => :course_students

  #many-many connection with assignments
  has_many :assignment_students, :foreign_key => "student_id"
  has_many :assignments, :through => :assignment_students

  #Validations
  validates :first_name, presence: true
  #validates :middle_name, presence: true
  validates :last_name, presence: true


  def compileGrade
    grade = 0.0
    assignmentsDone = AssignmentStudent.where("student_id=?", student.id).to_a
    assignmentsDone.each { |assignment|
      grade += assignment.grade
    }
    grade
  end

end
