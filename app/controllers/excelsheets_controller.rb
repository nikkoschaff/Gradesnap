# Class handles IMPORTING spreadsheets
#
class ExcelsheetsController < ApplicationController
  # GET /spreadsheets
  # GET /spreadsheets.json
  def index
    @excelsheets = Excelsheet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @excelsheets }
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
    @excelsheet = Excelsheet.find(params[:id])
  end

  # POST /spreadsheets
  # POST /spreadsheets.json
  def create 
    @excelsheet = Excelsheet.new(params[:excelsheet])
    if @excelsheet.save
      
      #Student creation inc
      @excelsheet.datafile_to_students

      respond_to do |format|
        format.html {
          render :json => [@excelsheet.to_jq_upload].to_json,
                 :content_type => 'text/html',
                 :layout => false
        }
        format.json {
          render :json => [ @excelsheet.to_jq_upload ].to_json
        }
      end 
    else 
      render :json => [ @image.to_jq_upload.merge({ :error => "custom_failure" }) ].to_json
    end
  end 



  #using roo
  #import a spreadsheet to the db
  def import
    @excelsheet = Excelsheet.new
    respond_to do |format|
      format.html # import.html.erb
    end
  end

  def destroy
    @excelsheet = AssignmentStudents.find(params[:id])
    @excelsheet.destroy

    respond_to do |format|
      format.html { redirect_to :action => 'index', :controller => 'excelsheets' }
      format.json
    end
  end

end
