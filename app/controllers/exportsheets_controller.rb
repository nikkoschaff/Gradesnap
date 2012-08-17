class ExportsheetsController < ApplicationController

  before_filter :login_required
  # GET /exportsheets
  # GET /exportsheets.json
  def index
    @exportsheets = Exportsheet.order(:student)

    respond_to do |format|
      format.html # index.html.erb
      format.csv { send_data @exportsheets.to_csv }
      format.xls { send_data @exportsheets.to_csv(col_sep: "\t") }  
    end
  end

  # GET /exportsheets/1
  # GET /exportsheets/1.json
  def show
    @exportsheet = Exportsheet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @exportsheet }
    end
  end

  # Function assembles the current assignment's students and grades and formats csv and xls files of given information.
  def new
    #destroy all traces of an identical assignment before beginning
    #otherwise have the spreadsheet output be completely fucked up
    Exportsheet.delete_all(:assignment_id => params[:id].to_i)
    #query students and assignments
    @assignment = Assignment.where("id = ?", params[:id]).to_a.first
    if @assignment
      @ass_students  = AssignmentsStudents.where(" assignment_id = ?", params[:id]).to_a
      
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
      Rails.logger.info("qwz: #{@students_hash}")

      #create exportsheets
      counter = 0
      @students_hash.each{ |stdnt, ass_stdnt|
        if counter == @students_hash.size then
          break
        end
        @exportsheet = Exportsheet.new({
        :student => stdnt.first_name,
        :grade => ass_stdnt.grade.to_i,
        :assignment_id => @assignment.id
        })
        @exportsheet.save
        counter +=1
      }
    end

    #format html, csv, and xls formats
    respond_to do |format|
      format.html # new.html.erb
      format.csv { send_data @exportsheet.to_csv }
      format.xls {  send_data @exportsheet.to_csv(col_sep: "\t")  }
      #format.xls {  @students }

    end
  end

  # DELETE /exportsheets/1
  # DELETE /exportsheets/1.json
  def destroy
    @exportsheet = Exportsheet.find(params[:id])
    @exportsheet.destroy

    respond_to do |format|
      format.html { redirect_to exportsheets_url }
      format.json { head :no_content }
    end
  end
end
