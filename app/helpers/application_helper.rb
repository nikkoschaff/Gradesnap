module ApplicationHelper

	def currentIssueCount
		@issues = Issue.where("teacher_id=?", session[:user].teacher_id)
		@issues.size
	end

end
