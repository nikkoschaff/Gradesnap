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
  end

  def index
    @issues = Issue.where("teacher_id=?",session[:user].teacher_id)
  end

  def create
    #leave empty
  end

  def new
    redirect_to :action => 'index', :controller => 'issues'
  end

  def resolveAnswerverify
    if request.post?  
      resolved_answers = Hash.new()
      paramArr = params.to_a
      paramArr.each do |p|
        parr = p.to_a
        rownum = parr.first[0..parr.size-2].to_i
        if rownum > 0 then
          rownum -= 1
          unless resolved_answers.has_key?(rownum)
            resolved_answers[rownum] = ""
          end
          resolved_answers[rownum] = resolved_answers[rownum] + parr.first.last
        end
      end
      doAnswerVerify(resolved_answers, params[:assignment_student_id], params[:delpath], params[:ambiguous_answers], params[:assignment_id])
      Issue.delete(params[:issue_id])
      redirect_to :action => "index", :controller => 'issues'   
    end
  end

  def resolveNameverify
    if request.post?  
      doNameVerify(params[:student_id], params[:assignment_student_id], params[:delpath])
      Issue.delete(params[:issue_id])
      redirect_to :action => "index", :controller => 'issues'   
    end
  end

end
