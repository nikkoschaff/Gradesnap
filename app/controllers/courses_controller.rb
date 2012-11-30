class CoursesController < ApplicationController

  before_filter :login_required

  def index
    @courses = Course.where("teacher_id=?", session[:user].teacher_id)
  end

  def show
    @course = Course.find(params[:id])
    flash[:course_id] = @course.id
    flash.keep
  end

  def new
    @course = Course.new
  end

  def edit
    @course = Course.find(params[:id])
  end

  def create
    @course = Course.new(params[:course])
    @course.teacher_id = session[:user].teacher_id
    if @course.save
	     redirect_to :action => 'index'
    end
  end

  def update
    @course = Course.find(params[:id])
  
    if @course.update_attributes(params[:course])
      redirect_to :action => :show
    else
      render :action => :edit
    end
  end

  def destroy
    @course = Course.find(params[:id])
    @course.courses_students.each(&:destroy)
    @course.assignments.each(&:destroy)
    @course.destroy
    redirect_to :action => :index
  end
  
end
