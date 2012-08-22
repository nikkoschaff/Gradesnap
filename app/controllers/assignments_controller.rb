class AssignmentsController < ApplicationController

  before_filter :login_required

  def edit
    #leave empty
    redirect_to :action => 'index', :controller => 'assignments'
  end

  def show
    if @assignment = Assignment.find(params[:id].to_i)    
      @show_hash_assignment = showHash("assignment" , @assignment)

      if !@show_hash_assignment[:assignmentsstudents].empty?
        
        # assemble student => ass_stdnt hash 
        # that hash to be used to write to the exportsheet record
        @students_hash = Hash.new
        dem_students = Student.where("course_id = ?", @assignment.course_id)
        counter = 0
        @show_hash_assignment[:assignmentsstudents].each{ |ass_stdnt|
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
    respond_to do |format|
      format.html #show.html.erb
    end
  end

  def index
    @assignments = Assignment.where("email=?", session[:user].email).to_a
    @courseAssignments = Array.new()
    @courses = Course.where("teacher_id=?",session[:user].teacher_id)
    @courses.each { |course|
	@courseAssignments.push [course, Assignment.where("course_id=?",course.id).to_a]
    }    

    respond_to do |format|
      format.html #index.html.erb
    end
  end

  def create
  	@assignment = Assignment.new(params[:assignment])
    @assignment.course_id = params[:assignment][:course_id]
  	if @assignment.save
      @assignment.answer_key = ""
      @assignment.save
      flash[:assignment_id] = @assignment.id
      flash.keep
  		render "key"
  	else 
      render "new"
    end
  end

  def key
    @assignment = Assignment.find(flash[:assignment_id])
    flash.keep
	  sheets = @assignment.scansheets.all
    if sheets.length > 0 then
    	@scansheet = sheets.to_a.last
	    unless @assignment.readKey( @scansheet ) == ""
	    	redirect_to :action => "new", :controller => "scansheets" 
	    else
	    	redirect_to :action => "key", :controller => "assignments"
	    end
    end
  end

  def new
  	@assignment = Assignment.new
    @courses = Course.where( "teacher_id=?", session[:user].teacher_id )  

  	respond_to do |format| 
  		format.html
  	end
  end

  # the GET side of the skeleton assignment creation
  def make
    @assignment = Assignment.new
    @courses = Course.where( "teacher_id=?", session[:user].teacher_id )  

    respond_to do |format| 
      format.html
    end
  end

  # the POST side of the skeleton assignment creation
  def post_make
    @assignment = Assignment.new(params[:assignment])
    @assignment.course_id = params[:assignment][:course_id]
    if @assignment.save
      @assignment.answer_key = ""
      @assignment.save
      flash[:assignment_id] = @assignment.id
      flash.keep
      redirect_to :action => 'index', :controller => 'assignments'
    else 
      redirect_to :action => 'dashboard', :controller => 'sessions'
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.json
  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.assignments_students.each(&:destroy)
    @assignment.destroy    


    respond_to do |format|
      format.html { redirect_to assignments_url }
      format.json { head :no_content }
    end
  end


end
