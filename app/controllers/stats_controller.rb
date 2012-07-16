class StatsController < ApplicationController

  before_filter :login_required

  # html rendering function
  # this brings the browser to the students.html page
  def students
  	render "students"
  end

  # html rendering function
  # this brings the browser to the assignments.html page
  def assignments
    render "assignments"
  end

    # html rendering function
  # this brings the browser to the courses.html page
  def courses
    @courses = Course.where("teacher_id=?",session[:user].teacher_id)
    render "courses"
  end

  def index
    @teacher = Teacher.find(session[:user].teacher_id)
    respond_to do |format|
      format.html # index.html.erb
    end    
  end

  def show
    flash[:code] = params[:code]
    flash.keep
    @course = nil
    @assignment = nil
    @student = nil
    case flash[:code]
      when "1"
        @course = Course.find(params[:id])
      when "2" 
        @assignment = Assignment.find(params[:id])
      when "3"
        @student = Student.find(params[:id])
    end
    respond_to do |format|
      format.html # show.html.erb
    end    
  end

end
