module IssuesHelper


	def issueCodeToPagename
		code = params[:code]
		pages = Hash.new()
		pages[1] => "answerverify"
		pages[2] => "nameverify"
		pages[code]
	end


	def prepAnswerverify

	end

end
