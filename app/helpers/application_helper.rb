include ReCaptcha::ViewHelper

module ApplicationHelper

	def currentIssueCount
		@issues = Issue.where("teacher_id=?", session[:user].teacher_id)
		@issues.size
	end

	def getController
	  url = request.fullpath 
	  url_arr = url.split('/') 
	  controller = url_arr[1]
	end

end
