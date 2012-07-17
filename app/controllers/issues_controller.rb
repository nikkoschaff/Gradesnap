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
    respond_to do |format|
      format.html #index.html.erb
    end
  end

  def create
    #leave empty
  end

  def new
    #leave empty
  end

  def resolve
    @issue = Issue.find(params[:id])
    @showHash = prepAnswerverify(@issue)
    render "#{@showHash[:pagename]}"
  end


end
