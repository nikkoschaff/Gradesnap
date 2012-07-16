class AssignmentsController < ApplicationController

  before_filter :login_required

  def edit
    #leave empty
  end

  def show
    @assignment = Assignment.find(params[:id])    
    @showHash = @assignment.prepShowAssignment
    respond_to do |format|
      format.html #show.html.erb
    end
  end

=begin
  #Select a course
  def select_course
    @courses = Course.all.to_a
    @course_name_array = Array.new 
    @courses.each{|element| 
      @course_name_array.push(element.name)
    }
    flash[:course] = @course = "k"  #name of course
    flash.keep
    respond_to do |format|
      format.html
    end
  end

  #Select an assignment
  def select_assignment
    @assignments = Assignment.all.to_a
    @assignment_name_array = Array.new 
    @assignments.each{|element| 
      @assignment_name_array.push(element.name)
    }
    @assignment = "k"  #name of assignment
    flash[:assignment] = "kno"
    #flash.keep
    respond_to do |format|
      format.html
    end
  end
=end

  def index
    @assignments = Assignment.where("email=?", session[:user].email).to_a
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

end
