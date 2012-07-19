class DisplaysheetsController < ApplicationController
  # GET /displaysheets
  # GET /displaysheets.json
  def index
    @displaysheets = Displaysheet.order(:student)

    respond_to do |format|
      format.html # index.html.erb
      format.csv { send_data @displaysheets.to_csv }
      format.xls { send_data @displaysheets.to_csv(col_sep: "\t") }  
    end
  end

  # GET /displaysheets/1
  # GET /displaysheets/1.json
  def show
    @displaysheet = Displaysheet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @displaysheet }
    end
  end

  # Function assembles the current assignment's students and grades and formats csv and xls files of given information.
  def new
    #destroy all traces of an identical assignment before beginning
    #otherwise have the spreadsheet output be completely fucked up
    Displaysheet.delete_all(:assignment_id => params[:id].to_i)
    #query students and assignments
    @assignment = Assignment.where("id = ?", params[:id]).to_a.first
    @ass_students  = AssignmentStudents.where(" assignment_id = ?", params[:id]).to_a
    
    # assemble student => ass_stdnt hash 
    # that hash to be used to write to the displaysheet record
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
    Rails.logger.info("qwz: #{@students_hash}")

    #create displaysheets
    counter = 0
    @students_hash.each{ |stdnt, ass_stdnt|
      if counter == @students_hash.size then
        break
      end
      @displaysheet = Displaysheet.new({
      :student => stdnt.first_name,
      :grade => ass_stdnt.grade.to_i,
      :assignment_id => @assignment.id
      })
      @displaysheet.save
      counter +=1
    }

    #format html, csv, and xls formats
    respond_to do |format|
      format.html # new.html.erb
      format.csv { send_data @displaysheet.to_csv }
      format.xls {  send_data @displaysheet.to_csv(col_sep: "\t")  }
      #format.xls {  @students }

    end
  end

  # GET /displaysheets/1/edit
  def edit
    @displaysheet = Displaysheet.find(params[:id])
  end

  # POST /displaysheets
  # POST /displaysheets.json
 # def create
  #  @displaysheet = Displaysheet.new(params[:displaysheet])#

  #  respond_to do |format|
  #    if @displaysheet.save
  #      format.html { redirect_to @displaysheet, notice: 'Displaysheet was successfully created.' }
  ##      format.json { render json: @displaysheet, status: :created, location: @displaysheet }
   #   else
   #     format.html { render action: "new" }
   #     format.json { render json: @displaysheet.errors, status: :unprocessable_entity }
   #   end
   # end
  #end

  # PUT /displaysheets/1
  # PUT /displaysheets/1.json
  def update
    @displaysheet = Displaysheet.find(params[:id])

    respond_to do |format|
      if @displaysheet.update_attributes(params[:displaysheet])
        format.html { redirect_to @displaysheet, notice: 'Displaysheet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @displaysheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /displaysheets/1
  # DELETE /displaysheets/1.json
  def destroy
    @displaysheet = Displaysheet.find(params[:id])
    @displaysheet.destroy

    respond_to do |format|
      format.html { redirect_to displaysheets_url }
      format.json { head :no_content }
    end
  end
end
