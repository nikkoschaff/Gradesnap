class StudentsController < ApplicationController
  # GET /students
  # GET /students.json
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

    respond_to do |format|
      format.html #students.html.erb
    end
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @student = Student.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student }
    end
  end

  # GET /students/new
  # GET /students/new.json
  def new
    @student = Student.new
    @courses = Course.where("teacher_id=?", session[:user].teacher_id)
    @grade = 0.0

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student }
    end
  end

  # GET /students/1/edit
  def edit
    @courses = Course.where("teacher_id=?", session[:user].teacher_id)
    @student = Student.find(params[:id])
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(params[:student])
    if @student.save
      if @student.middle_name == nil
        @student.middle_name = " "
      end
	@student.save
      respond_to do |format|
      	format.html { redirect_to @student, notice: 'Student was successfully created.' }
      	format.json { render json: @student, status: :created, location: @student }
	end
    else
	respond_to do |format|
        	format.html { render action: "new" }
        	format.json { render json: @student.errors, status: :unprocessable_entity }
	end
    end
  end

  # PUT /students/1
  # PUT /students/1.json
  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    Student.destroy(params[:id])

    respond_to do |format|
      format.html { redirect_to :action => 'show', :controller => 'courses',
        :id => courseid }
      format.json { head :no_content }
    end
  end
end
