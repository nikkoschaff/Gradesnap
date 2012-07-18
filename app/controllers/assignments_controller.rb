class AssignmentsController < ApplicationController

  before_filter :login_required

  def edit
    #leave empty
  end

  def show
    @assignment = Assignment.find(params[:id])    
    @show_hash_assignment = showHash(2 , @assignment)
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

  #Function handles/begins the assignment modification process
 # def mod
 #    @assignment = Assignment.where("id=?", params[:id]).first
 #   @show_hash_assignment = showHash(2, @assignment)
 #   if @show_hash_assignment
 #     #Rails.logger.info( "datas1 #{@show_hash_assignment[:students]}")
 #
 #     #update assignment students
 #     #prevent double entry
 #     @assignment.updateAssignmentStudents(@show_hash_assignment, params[:id])
 #
 #     @show_hash_assignment = showHash(2 , @assignment)
 #
 #     #assemble hash {student object => assignment_student object}
 #     @students_hash = Hash.new
 #     counter = 0
 #     #Rails.logger.info( "datas2 #{@show_hash_assignment[:students]}")
 #     @show_hash_assignment[:students].each{ |s|
 #       @students_hash[s] = @show_hash_assignment[:assignmentstudents][counter]
 #      counter += 1
 #     }
 #     #Rails.logger.info( "datas3 #{@students_hash}")
 #    #Rails.logger.info( "hrey#{ @show_hash_assignment[:assignmentstudents]}")
 #     @ass = AssignmentStudents.new
 #   end
 #   respond_to do |format| 
 #     format.html
 #   end
 # end

 # def post_mod
 #   redirect_to :action => 'dashboard', :controller => 'sessions'
 # end

 # def update
 #  Rails.logger.info(":ass4 #{@ass}") 
 #
 #   ass = AssignmentStudents.find(@ass.id)
 #    if ass
 #      ass.grade = params[:grade]
 #       ass.save
 #    end
 #   
 #   redirect_to :action => 'index', :controller => 'assignments'
 #
 # end

end
