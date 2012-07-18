class StatsController < ApplicationController

  before_filter :login_required

  # html rendering function
  # this brings the browser to the assignments.html page
  def assignments
    #@show_hash_assignment = prepHash(2,) #hash of assignment stats

    @assignments = Assignment.where("email=?",session[:user].email)
    respond_to do |format|
      format.html #assignments.html.erb
    end
  end

    # html rendering function
  # this brings the browser to the courses.html page
  def courses
    #@show_hash_course = prepHash(1,)

    @courses = Course.where("teacher_id=?",session[:user].teacher_id)
    respond_to do |format|
      format.html #courses.html.erb
    end
  end

  # html rendering function
  # this brings the browser to the students.html page
  def students
    #@show_hash_student = prepHash(3, ) #hash of student stats
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
    Rails.logger.info( "syndrome #{@students}")
    @students.uniq!

    respond_to do |format|
      format.html #students.html.erb
    end
  end

######################################################################
######################   I AM A BLOCK   ##############################
######################################################################

  def index
    @teacher = Teacher.where("id=?", session[:user].teacher_id).to_a.last
    respond_to do |format|
      format.html # index.html.erb
    end    
  end



  #Function called when a specific student, course, or assignment is selected for show
  def show 
    flash[:code] = params[:code]
    flash.keep
    case flash[:code]
      when "1"
        @course = Course.find(params[:id])
        @show_hash_course = showHash(1, @course) #hash of course stats
      when "2" 
        @assignment = Assignment.find(params[:id])
        @show_hash_assignment = showHash(2, @assignment) #hash of assignment stats
      when "3"
        @student = Student.find(params[:id])
        @show_hash_student = showHash(3, @student) #hash of student stats
    end
    respond_to do |format|
      format.html # show.html.erb
    end
  end
   
end
