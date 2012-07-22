class Course < ActiveRecord::Base
  attr_accessible :name, :teacher_id

  belongs_to :teacher, :foreign_key => ":teacher_id"
  has_many :assignments

  #Many-many connection with students
  has_many :course_students, :foreign_key => ":course_id"
  has_many :students, :through => :course_students

  #Validations
  validates :name, :presence => true

  def courseGrades
    students = Student.where("course_id=?", self.id).to_a
    grades = Array.new()
    students.each { |student|
      grades.push(student.grade)
    }
    grades
  end

  def self.courseStudents
    students = Student.where("course_id=?", self.id).to_a
  end
  
end
