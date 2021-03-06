class StatsController < ApplicationController

  before_filter :login_required

  # html rendering function
  # this brings the browser to the assignments.html page
  def assignments
    @assignments = Assignment.where("email=?",session[:user].email)
  end

  # html rendering function
  # this brings the browser to the courses.html page
  def courses
    @courses = Course.where("teacher_id=?",session[:user].teacher_id)
  end

  # html rendering function
  # this brings the browser to the students.html page
  def students
    @courses = Course.where("teacher_id=?",session[:user].teacher_id)
    student_ids = Array.new
    @courses.each{ |c|
      student_ids.push(c.courseStudents)
    }
    student_ids.each{ |array|
      array.each{ |student|
        @students.push(student)
      }
    }
    @students.uniq!
  end

  #Function called when a specific student, course, or assignment is selected for show
  def show 
    @code = params[:code]
    case @code
      when "course"
        @course = Course.find(params[:id].to_i)
        @show_hash_course = showHash(@code, @course) #hash of course stats
      when "assignment" 
        @assignment = Assignment.find(params[:id].to_i)
        @show_hash_assignment = showHash(@code, @assignment) #hash of assignment stats
      when "student"
        @student = Student.find(params[:id].to_i)
        @show_hash_student = showHash(@code, @student) #hash of student stats
    end
  end
   
end
