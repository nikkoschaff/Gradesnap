class StudentsController < ApplicationController

  def index
    #Creates an array of courses and students, where each object is a 
    #2-part array: First part is the course, second is array of students in it

    @courses = Course.where("teacher_id=?",session[:user].teacher_id).to_a
    @courseStudents = Array.new()
    @courses.each{ |c|
      cs = Array.new()
      cs.push(c)
      cs.push( Student.where("course_id=?",c.id).to_a )
      @courseStudents.push(cs)      
    }
  end

  def show
    @student = Student.find(params[:id])
  end

  def new
    @student = Student.new
    @courses = Course.where("teacher_id=?", session[:user].teacher_id)
    @grade = 0.0
  end

  def edit
    @courses = Course.where("teacher_id=?", session[:user].teacher_id)
    @student = Student.find(params[:id])
  end

  def create
    @student = Student.new(params[:student])
    if @student.save
      if @student.middle_name == nil
        @student.middle_name = " "
      end
	     @student.grade = 0.0
	     @student.save

      redirect_to :action => :index
    else
      redirect_to :action => :new
    end
  end

  def update
    @student = Student.find(params[:id])

    if @student.update_attributes(params[:student])
      redirect_to :action => :show
    else
      redirect_to :action => :edit
    end
  end

  def destroy
    @student = Student.find(params[:id])
    @student.courses_students.each(&:destroy)
    @student.assignments_students.each(&:destroy)
    @student.destroy
  end
end
