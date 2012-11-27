# Class handles IMPORTING spreadsheets
#
class ImportsheetsController < ApplicationController

  before_filter :login_required

  def new
    redirect_to :action => 'import', :controller => 'importsheets'
  end

  def edit
    @importsheet = Importsheet.find(params[:id])
  end

  def create 
    flash.keep
    @importsheet = Importsheet.new(params[:importsheet])
    if @importsheet.save
      @importsheet.datafile_to_students(@importsheet.course_id)
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
  end

  def destroy
    @importsheet = AssignmentsStudents.find(params[:id])
    @importsheet.destroy
  end

end
