class AssignmentStudentsController < ApplicationController
  # GET /assignment_students
  # GET /assignment_students.json
  def index

    @ass_students = AssignmentStudents.where("assignment_id=?", request.fullpath[-1,1].to_i).to_a
    Rails.logger.info("~~~~~~~~~~~~~: #{@ass_students}")

    if !@ass_students.empty?
      @assignment = Assignment.where("id = ?", @ass_students.to_a.first.assignment_id).to_a.first
      
      # assemble student => ass_stdnt hash 
      # that hash to be used to write to the exportsheet record
      @students_hash = Hash.new
      dem_students = Student.where("course_id = ?", @assignment.course_id)
      Rails.logger.info("qwy: #{dem_students}")
      counter = 0
      @ass_students.each{ |ass_stdnt|
        s = dem_students[counter]
        if !@students_hash.key?(s)  and s != nil then
          h = Hash.new
          h[s] = ass_stdnt
          if h != nil then
            @students_hash.merge!( h )
          end
        end
        counter += 1
      }
      Rails.logger.info("qwz2: #{@students_hash}")
    end 
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

  #Function handles/begins the assignment modification process
  def mod
    Rails.logger.info("point4 #{@list_of_grades}" )
    Rails.logger.info("point5 #{params}" )

    # get the grade params

    grade_params = Hash.new
    params.each{ |key, value|
      begin
        key = key.to_i
        if key.kind_of?(Fixnum) && key != 0
          grade_params[key] = value
        end
      rescue Error
          # ignore
      end
    }

    grade_params.each{ |key,value|
      as = AssignmentStudents.find(key.to_i)
      as.grade = value
      as.save
    } 
    redirect_to :action => 'index', :controller => 'assignment_students'
  end

end
