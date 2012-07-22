require("Imgproc")
module IssuesHelper


	def prepAnswerverify(issue)
		@showHash = Hash.new()
		@showHash[:issue] = issue
		@showHash[:pagename] = issueCodeToPagename(issue.code)
  		
  		scansheet = Scansheet.find(issue.row_id)
  		@showHash[:scansheet] = scansheet		
		
		filename = scansheet.image.path.split("/").last
		iproc = Imgproc.new
		iproc.prepShowImage("#{scansheet.image.to_s}",
		 "#{Rails.root}/app/assets/images/uploads/scansheet/image/#{scansheet.id}/~#{filename}")
  		path = "/assets/uploads/scansheet/image/#{scansheet.id}/~#{filename}"
  		@showHash[:path] = path
  		@showHash[:delpath] = "#{Rails.root}/app/assets/images/uploads/scansheet/image/#{scansheet.id}/~#{filename}"

  		ambigAnswers = scansheet.ambiguous_answers.split("~")
  		ambigHash = Hash.new
  		ambigAnswers.each { |amb|
  			ambarr = amb.split(" ")
  			ambigHash[Integer(ambarr[0])] = ambarr[1]
  		}
  		@showHash[:ambiguous_answers] = ambigHash
		

  		assignment_student = AssignmentStudents.where("scansheet_id=?",scansheet.id).to_a.last
  		unless assignment_student == nil
			@showHash[:student] = Student.find(assignment_student.student_id)
			@showHash[:assignment_student_id] = assignment_student.id
		else
			@showHash[:student] = nil
			@showHash[:assignment_student_id] = nil			
		end
		@showHash[:assignment_id] = scansheet.assignment_id

		@showHash
	end


	def doAnswerVerify(resolved_answers, 
		assignment_student_id, delpath, ambiguous_answers, assignment_id)
		resultsArr = Array.new()
		assignment = Assignment.find(assignment_id)
		astu = nil
		unless assignment_student_id == ""
			astu = AssignmentStudents.find(assignment_student_id)
			resultsArr = astu.results.split("~")
		else 
			resultsArr = assignment.answer_key.split("~")
		end

		resolveArr = resolved_answers.to_a
		ambigAns = eval(ambiguous_answers)
		resolveArr.each { |ans|
			#Set to db format then insert
			resultsArr[ans.first] = answersToDbFormat(ans.last)
			ambigAns.delete(ans.first)
		}
		# Solve issue of empty fields not coming through as regular params
		unless ambigAns.empty? then
			ambigAns.each { |key, value|
				resultsArr[key.to_i] = " , , , , "
			}
		end
		newResults = resultsArr.join("~")

		# If student, save and update grades, otherwise (key) save and update all
		unless assignment_student_id == ""
			astu.results = newResults
			astu.grade = gradeStudent( astu.results, astu.answer_key )  
			astu.save!
			student = Student.find(astu.student_id)
			student.compileGrade
			student.save!
		else
			assignment.answer_key = newResults
			assignmentStudents = AssignmentStudents.where("assignment_id=?",assignment.id)
			assignmentStudents.each { |assStu|
				assStu.grade = gradeStudent( assStu.results, newResults )
				assStu.save!
				student = Student.find(assStu.student_id)
				student.compileGrade
				student.save!
			}
			assignment.save!
		end

		FileUtils.remove_file(delpath)
	end

	def prepNameverify(issue)
		@showHash = Hash.new()
		@showHash[:issue] = issue
		@showHash[:pagename] = issueCodeToPagename(issue.code)
  		
  		scansheet = Scansheet.find(issue.row_id)
		
		filename = scansheet.image.path.split("/").last
		iproc = Imgproc.new
		iproc.prepShowImage("#{scansheet.image.to_s}",
		 "#{Rails.root}/app/assets/images/uploads/scansheet/image/#{scansheet.id}/~#{filename}")
  		path = "/assets/uploads/scansheet/image/#{scansheet.id}/~#{filename}"
  		@showHash[:path] = path
  		@showHash[:delpath] = "#{Rails.root}/app/assets/images/uploads/scansheet/image/#{scansheet.id}/~#{filename}"
  		
  		assignment = Assignment.find(scansheet.assignment_id)
  		course = Course.find(assignment.course_id)

  		#Filtering students down to ones who haven't been matched yet.
  		students = Student.where("course_id=?",course.id)
  		unmatchedStudents = Array.new()
  		students.each { |student|
  			#Keep out the obviously unmatched "fake" students
  			unless student.first_name[0] == "~"
  				gradedAssignmentStudent = AssignmentStudents.where("student_id=? and assignment_id=?"
  					,student.id,assignment.id)
  				# Add if there doesnt exist a record for this student on this assignmen
  				if gradedAssignmentStudent == nil
  					unmatchedStudents.push(student)
  				end
  			end
  		}

  		@showHash[:students] = unmatchedStudents
  		assignmentStudent = AssignmentStudents.where("scansheet_id=?",scansheet.id).to_a.last
		@showHash[:student] = Student.find(assignmentStudent.student_id)
		
		@showHash[:assignmentStudent] = assignmentStudent

		@showHash
	end


	def doNameVerify(student_id, assignment_student_id, delpath)
		assignmentStudent = AssignmentStudents.find(assignment_student_id)
		student = Student.find(student_id)
		oldStudent = assignmentStudent.student_id
		assignmentStudent.student_id = student_id
		Student.delete(oldStudent)
		assignmentStudent.save!
		student.compileGrade
		student.save!
		FileUtils.remove_file(delpath)
	end


	def issueCodeToPagename(code)
		case code
			when 1
				return "answerverify"
			when 2 
				return "nameverify"
		end
	end

	def answersToDbFormat(answers)
		letters = ["a","b","c","d","e"]
		ansarr = answers.split("")
		letters.each do |letter|
			unless ansarr.include?(letter) then
				letters[letters.index(letter)] = " "
			end
		end
		row = letters.join(",")
		row
	end

end
