class ScansheetsController < ApplicationController
  
  before_filter :login_required

  def index
    respond_to do |format|
    	format.html # index.html.erb
    	format.json { render :json => @scansheets.collect { |p| p.to_jq_upload }.to_json }
    end
  end

  def create
    @scansheet = Scansheet.new(params[:scansheet])
    flash.keep
    @assignment = Assignment.find(flash[:assignment_id])
    @scansheet.assignment_id = @assignment.id
    if @scansheet.save
      
      #Read, unless it's a key
      unless @assignment.answer_key == "" then
        sheets = Array.new()
        sheets.push(@scansheet)
        @assignment.readImages( sheets )
      end

	    respond_to do |format|
		    format.html {
		      render :json => [@scansheet.to_jq_upload].to_json,
		             :content_type => 'text/html',
		             :layout => false
		    }
		    format.json {
		      render :json => [ @scansheet.to_jq_upload ].to_json
		    }
	      end 
    else 
      render :json => [ @image.to_jq_upload.merge({ :error => "custom_failure" }) ].to_json
    end
  end

  def destroy
    @scansheet = Scansheet.find(params[:id])
    @scansheet.destroy
    render :json => true
  end


  def new
	 @scansheet = Scansheet.new
   flash.keep
  	respond_to do |format| 
  		format.html # new.html.erb
  		format.json { render json: @scansheet }
  	end
  end

  def edit
	 @scansheet = Scansheet.find(params[:id])
    respond_to do |format| 
      format.html # new.html.erb
    end
  end

  def show
    @scansheet = Scansheet.find(params[:id])
    respond_to do |format| 
      format.html # new.html.erb
    end
  end

end
