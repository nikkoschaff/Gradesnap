class IssuesController < ApplicationController
  before_filter :login_required
  include IssuesHelper

  def edit
    #leave empty
  end

  def show
    @issue = Issue.find(params[:id])
    @showHash = Hash.new()
    case @issue.code
      when 1
        @showHash = prepAnswerverify(@issue)
      when 2
        @showHash = prepNameverify(@issue)
    end
    respond_to do |format|
      format.html #resolve.html.erb
    end
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
end
