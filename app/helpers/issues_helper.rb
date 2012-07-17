module IssuesHelper

	def issueCodeToPagename(code)
		case code
			when 1
				return "answerverify"
			when 2 
				return "nameverify"
		end
	end

	def prepAnswerverify(issue)
		@showHash = Hash.new()
		@showHash[:issue] = issue
		@showHash[:pagename] = issueCodeToPagename(issue.code)
  		
  		@scansheet = Scansheet.find(issue.row_id)
  		@showHash[:scansheet] = @scansheet		
		
		filename = @scansheet.image.path.split("/").last 
		iproc = Imgproc.new
		iproc.prepShowImage("#{@scansheet.image.to_s}")
  		path = "/assets/uploads/scansheet/image/#{@scansheet.id}/~#{filename}"
  		@showHash[:path] = path
  		
  		ambigAnswers = @scansheet.ambiguous_answers.split("~")
  		ambigHash = Hash.new
  		ambigAnswers.each { |amb|
  			ambarr = amb.split(" ")
  			ambigHash[Integer(ambarr[0])] = ambarr[1]
  		}
  		@showHash[:ambiguous_answers] = ambigHash
		
  		assignmentStudent = AssignmentStudents.where("scansheet_id=?",@scansheet.id).to_a.last
		@showHash[:student] = Student.find(assignmentStudent.student_id)

		@showHash
	end


	def doAnswerverify
		# TODO function to make necessary changes
	end

	def prepNameverify(issue)
		#TODO
	end

end
