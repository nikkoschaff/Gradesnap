class Student < ActiveRecord::Base
  attr_accessible :first_name,
		:middle_name,
		:last_name,
    :course_id,
    :grade

  #many-many connection with courses
  has_many :courses_students, :foreign_key => "student_id"
  has_many :courses, :through => :courses_students

  #many-many connection with assignments
  has_many :assignments_students, :foreign_key => "student_id"
  has_many :assignments, :through => :assignments_students

  #Validations
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :course_id, :presence => true 


  def courses_students
	return CoursesStudents.where("student_id=?",self.id)
  end

  def assignments_students
	return AssignmentsStudents.where("student_id=?",self.id)
  end



  def full_name
    "#{self.first_name} #{self.middle_name} #{self.last_name}"
  end

  def compileGrade
    grade = 0.0
    assignmentsDone = AssignmentsStudents.where("student_id=?", self.id).to_a
    assignmentsDone.each { |assignment|
      grade += assignment.grade
    }
    grade
  end

end
