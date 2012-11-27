class AssignmentsStudentsController < ApplicationController

  before_filter :login_required

  def index
    @ass_students = AssignmentsStudents.where("assignment_id=?", request.fullpath[-1,1].to_i).to_a

    if !@ass_students.empty?
      @assignment = Assignment.where("id = ?", @ass_students.to_a.first.assignment_id).to_a.first
      
      # assemble student => ass_stdnt hash 
      # that hash to be used to write to the exportsheet record
      @students_hash = Hash.new
      dem_students = Student.where("course_id = ?", @assignment.course_id)
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
    end 
  end

  def show
    @assignment_student = AssignmentsStudents.find(params[:id])
    @student = Student.where("id=?", @assignment_student.student_id).first
  end

  def new
    @assignment_student = AssignmentsStudents.new
  end

  def edit
    @assignment_student = AssignmentsStudents.find(params[:id])
  end

  def create
    @assignment_student = AssignmentsStudents.new(params[:assignment_student])
    if @assignment_student.save
      redirect_to :action => :index
    else
      redirect_to :action => :new
    end
  end

  def update
    @assignment_student = AssignmentsStudents.find(params[:id])

    if @assignment_student.update_attributes(params[:assignment_student])
      redirect_to :action => :index
    else
      redirect_to :action => :edit
    end
  end

  def destroy
    @assignment_student = AssignmentsStudents.find(params[:id])
    @assignment_student.destroy
  end

  #Function handles/begins the assignment modification process
  def mod
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
      as = AssignmentsStudents.find(key.to_i)
      as.grade = value
      as.save
    } 
    redirect_to :action => 'index', :controller => 'assignments_students'
  end

end
