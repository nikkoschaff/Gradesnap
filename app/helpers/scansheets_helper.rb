module ScansheetsHelper

	def studentFromScansheetId
		@assignmentStudent = AssignmentsStudents.where("scansheet_id=?",params[:id]).to_a.last
		@student = Student.find(@assignmentStudent.student_id)
		@student
	end

	def assignmentFromScansheetId
		@scansheet = Scansheet.find(params[:id])
		@assignment = Assignment.find(@scansheet.assignment_id)
		@assignment
	end

end
