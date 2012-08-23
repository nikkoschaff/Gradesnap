class AssignmentsStudents < ActiveRecord::Base

  # grade is a float of recorded grade
  # results is a results-style string of results
  # answer key is there for scramble
  # answer key is a results-style string, local to the test, if using scramble, 
  # use this answer key, ese use from assingment

  attr_accessible :assignment_id, :student_id, :scansheet_id, :grade,
  					:results, :answer_key

  #many-many connection, assignment student
  belongs_to :assignments
  belongs_to :students


  #validation
  validates :assignment_id, :presence => true
  validates :student_id, :presence => true

end
