class IssuesController < ApplicationController
  before_filter :login_required

  def edit
    #leave empty
  end

  def show
    #leave empty
  end

  def index
    @issues = Issue.where("teacher_id=?",session[:user].teacher_id)
    Student.all.to_a.each { |s| 
    	Rails.logger.info(s.first_name)
 	Rails.logger.info(s.middle_name)
	Rails.logger.info(s.last_name) 
   }
	Rails.logger.info(Student.all.to_a.size)
    respond_to do |format|
      format.html #index.html.erb
    end
  end

  def create

  end

  def new

  end


end
