require 'iconv'

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

  # GET /spreadsheets/1
  # GET /spreadsheets/1.json
#  def show
#    @spreadsheet = Spreadsheet.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.json { render json: @spreadsheet }
#    end
#  end

  # GET /spreadsheets/new
  # GET /spreadsheets/new.json
  def new
    #@excelsheet = Excelsheet.new
    @assignment = Assignment.where("email = ?", session[:user].email).last 
    @students  = AssignmentStudents.where(" assignment_id = ?", @assignment.id)
    @student_names = Array.new

    @students.each{ |ass_stdnt|
      stdnt = Student.where("id = ?", ass_stdnt.student_id).last
      name = stdnt.first_name[0].capitalize + stdnt.middle_name[0] + stdnt.last_name
      @student_names.push(name)
    }

    respond_to do |format|
      format.html # new.html.erb
      #format.json { render json: @excelsheets }
      format.csv { send_data @students.to_csv }
      format.xls #{ send_data @students.to_csv(col_sep: "\t") }
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


end
