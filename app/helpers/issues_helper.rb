require("Imgproc")
module IssuesHelper


	def prepAnswerverify(issue)
		@showHash = Hash.new()
		@showHash[:issue] = issue
		@showHash[:pagename] = issueCodeToPagename(issue.code)
  		
  		@scansheet = Scansheet.find(issue.row_id)
  		@showHash[:scansheet] = @scansheet		
		
		filename = @scansheet.image.path.split("/").last
		iproc = Imgproc.new
		iproc.prepShowImage("#{@scansheet.image.to_s}",
		 "#{Rails.root}/app/assets/images/uploads/scansheet/image/#{@scansheet.id}/~#{filename}")
  		path = "/assets/uploads/scansheet/image/#{@scansheet.id}/~#{filename}"
  		@showHash[:path] = path
  		@showHash[:delpath] = "#{Rails.root}/app/assets/images/uploads/scansheet/image/#{@scansheet.id}/~#{filename}"

  		ambigAnswers = @scansheet.ambiguous_answers.split("~")
  		ambigHash = Hash.new
  		ambigAnswers.each { |amb|
  			ambarr = amb.split(" ")
  			ambigHash[Integer(ambarr[0])] = ambarr[1]
  		}
  		@showHash[:ambiguous_answers] = ambigHash
		
  		assignmentStudent = AssignmentStudents.where("scansheet_id=?",@scansheet.id).to_a.last
		@showHash[:student] = Student.find(assignmentStudent.student_id)
		@showHash[:assignmentStudent] = assignmentStudent

		@showHash
	end


	def doAnswerVerify(issue_id, resolved_answers, assignment_student_id, delpath)
		status = true
		issue = Issue.find(issue_id)
		astu = AssignmentStudents.find(assignment_student_id)
		results = astu.results.to_a
		resultsArr = results.split("~")
		resolveArr = resolved_answers.to_a
		resolveArr.each { |ans|
			index = ans.first.to_i - 1 
			formattedAns = readableAnswerToDatabaseFormat(ans.last)
			if formattedAns == false then
				return false
			end
			resultsArr[index] = formattedAns
		}

		strResults = resultsArr.join("~")
		gradeStudent( strResults, astu.answer_key )  
		student = Student.find(astu.student_id)
		student.compileGrade

		FileUtils.remove_file(delpath)
		status
	end

	def prepNameverify(issue)
		@showHash = Hash.new()
		@showHash[:issue] = issue
		@showHash[:pagename] = issueCodeToPagename(issue.code)
  		
  		@scansheet = Scansheet.find(issue.row_id)
  		@showHash[:scansheet] = @scansheet		
		
		filename = @scansheet.image.path.split("/").last
		iproc = Imgproc.new
		iproc.prepShowImage("#{@scansheet.image.to_s}",
		 "#{Rails.root}/app/assets/images/uploads/scansheet/image/#{@scansheet.id}/~#{filename}")
  		path = "/assets/uploads/scansheet/image/#{@scansheet.id}/~#{filename}"
  		@showHash[:path] = path
  		@showHash[:delpath] = "#{Rails.root}/app/assets/images/uploads/scansheet/image/#{@scansheet.id}/~#{filename}"
  		
  		@assignment = Assignment.find(@scansheet.assignment_id)
  		@showHash[:course] = Course.find(assignment.course_id)
  		@showHash[:students] = Student.where("course_id=?",@showHash[:course].id)
		
  		assignmentStudent = AssignmentStudents.where("scansheet_id=?",@scansheet.id).to_a.last
		@showHash[:student] = Student.find(assignmentStudent.student_id)

		# TODO get name right

		@showHash
	end


	def doNameVerify
		status = false
		# TODO function to make necessary changes
		# - Change student and associations
		# Delete temp image
		# Delete temp student
		status
	end


	def issueCodeToPagename(code)
		case code
			when 1
				return "answerverify"
			when 2 
				return "nameverify"
		end
	end


	def readableAnswerToDatabaseFormat( answer )
		newAns = ""
		answerArr = answer.split("")
		fullAnswerArr = "abcde".split("")

		if answer.size < 0 or answer.size > 5
			return false 
		end
		answerArr.each { |ans|
			unless ans =~ /[a-e]/
				return false
			end
		}

		count = 0
		fullAnswerArr.each {
			unless answerArr.include?(fullAnswerArr[count])
				fullAnswerArr[count] = " "
			end
			count += 1
		}
		newAns = fullAnswerArr.join(",")
		newAns
	end



end
