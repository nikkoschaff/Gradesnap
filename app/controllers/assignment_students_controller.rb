class AssignmentStudentsController < ApplicationController
  # GET /assignment_students
  # GET /assignment_students.json
  def index

    @assignment_students = AssignmentStudents.where("assignment_id=?", params[:id]).to_a

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @assignment_students }
    end
  end

  # GET /assignment_students/1
  # GET /assignment_students/1.json
  def show
    @assignment_student = AssignmentStudents.find(params[:id])
    @student = Student.where("id=?", @assignment_student.student_id).first
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @assignment_student }
    end
  end

  # GET /assignment_students/new
  # GET /assignment_students/new.json
  def new
    @assignment_student = AssignmentStudents.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @assignment_student }
    end
  end

  # GET /assignment_students/1/edit
  def edit
    @assignment_student = AssignmentStudents.find(params[:id])
  end

  # POST /assignment_students
  # POST /assignment_students.json
  def create
    @assignment_student = AssignmentStudents.new(params[:assignment_student])

    respond_to do |format|
      if @assignment_student.save
        format.html { redirect_to @assignment_student, notice: 'Assignment student was successfully created.' }
        format.json { render json: @assignment_student, status: :created, location: @assignment_student }
      else
        format.html { render action: "new" }
        format.json { render json: @assignment_student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /assignment_students/1
  # PUT /assignment_students/1.json
  def update
    @assignment_student = AssignmentStudents.find(params[:id])

    respond_to do |format|
      if @assignment_student.update_attributes(params[:assignment_student])
        format.html { redirect_to @assignment_student, notice: 'Assignment student was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @assignment_student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignment_students/1
  # DELETE /assignment_students/1.json
  def destroy
    @assignment_student = AssignmentStudents.find(params[:id])
    @assignment_student.destroy

    respond_to do |format|
      format.html { redirect_to assignment_students_url }
      format.json { head :no_content }
    end
  end
end
