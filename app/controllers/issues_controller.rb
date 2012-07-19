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

  def resolveAnswerverify
    if request.post?  
      resolved_answers = Hash.new()
      issue_id = params[:issue_id]
      assignment_student_id = params[:assignment_student_id]
      delpath = params[:delpath]
      paramArr = params.to_a
      paramArr.each do |p|
        if p.first.to_i > 0 then
          resolved_answers[p.first] = p.last
        end
      end
      if doAnswerVerify(issue_id, resolved_answers, assignment_student_id, delpath)
        #Issue.delete(issue_id)
        redirect_to :action => "index", :controller => 'issues'   
      else
        flash[:warning] = "Verification unsuccessful"
      end
    else
      flash[:warning] = "Verification unsuccessful"
    end
  end

  def resolveNameverify
    if request.post?  
      resolved_answers = Hash.new()
      issue_id = params[:issue_id]
      assignment_student_id = params[:assignment_student_id]
      delpath = params[:delpath]
      name = params[:name]
      if doAnswerVerify(issue_id, resolved_answers, assignment_student_id, delpath)
        #Issue.delete(issue_id)
        redirect_to :action => "index", :controller => 'issues'   
      else
        flash[:warning] = "Verification unsuccessful"
      end
    else
      flash[:warning] = "Verification unsuccessful"
    end
  end

end
