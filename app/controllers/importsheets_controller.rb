# Class handles IMPORTING spreadsheets
#
class ImportsheetsController < ApplicationController

  before_filter :login_required
  # GET /spreadsheets
  # GET /spreadsheets.json
  def index

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @importsheets }
    end
  end

  # GET /spreadsheets/new
  # GET /spreadsheets/new.json
  def new
    #query students and assignments
  #  @assignment = Assignment.where("email = ?", session[:user].email).last 
  #  @students  = AssignmentStudents.where(" assignment_id = ?", @assignment.id)

    #gather params for displaysheet
  #  @student_names = Array.new
  #  @students.each{ |ass_stdnt|
  #    stdnt = Student.where("id = ?", ass_stdnt.student_id).last
  #    name = stdnt.first_name[0].capitalize + stdnt.middle_name[0] + stdnt.last_name
  #    @student_names.push(name)
 #   }
    #create displaysheet


    respond_to do |format|
      format.html # new.html.erb
  #    format.csv { send_data @displaysheet.to_csv }
  #    format.xls {  send_data @displaysheet.to_csv(col_sep: "\t")  }
      #format.xls {  @students }

    end
  end

  # GET /spreadsheets/1/edit
  def edit
    @importsheet = Importsheet.find(params[:id])
  end

  # POST /spreadsheets
  # POST /spreadsheets.json
  def create 
    flash.keep
    Rails.logger.info "~~~~~~~~~~~~~~~~~~~~~~~~~#{params[:importsheet]}"
    @importsheet = Importsheet.new(params[:importsheet])
    Rails.logger.info "@@@@@@@@@@ #{flash[:course_id]}"
    Rails.logger.info "~~~~~~~~~~~~~~~~~~~~~~~~~#{@importsheet.course_id}"

    if @importsheet.save
      
      #Student creation inc
     # @teacher = Teacher.where("id=?",session[:user].teacher_id )
     # @course = Course.where("teacher_id=?", session[:user].teacher_id).first

      Rails.logger.info "~~~~~~~~~~~~~~~~~~~~~~~#{@importsheet.course_id}"

      @importsheet.datafile_to_students(@importsheet.course_id)
      Rails.logger.info "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

      respond_to do |format|
        format.html {
          render :json => [@importsheet.to_jq_upload].to_json,
                 :content_type => 'text/html',
                 :layout => false
        }
        format.json {
          render :json => [ @importsheet.to_jq_upload ].to_json
        }
      end 
    else 
      render :json => [ @image.to_jq_upload.merge({ :error => "custom_failure" }) ].to_json
    end
  end 

  #using roo
  #import a spreadsheet to the db
  def import
    @course_id = params[:course].to_i
    flash.keep
    @importsheet = Importsheet.new
    respond_to do |format|
      format.html # import.html.erb
    end
  end

  def destroy
    @importsheet = AssignmentStudents.find(params[:id])
    @importsheet.destroy

    respond_to do |format|
      format.html { redirect_to :action => 'index', :controller => 'importsheets' }
      format.json
    end
  end

end
