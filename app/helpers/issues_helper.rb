module IssuesHelper

	def issueCodeToPagename
		code = params[:code]
		pages = Hash.new()
		pages["1"] = "answerverify"
		pages["2"] = "nameverify"
		pages[code]
	end

	def prepAnswerverify
		@showHash = Hash.new()
		@showHash["issue"] = params[:issue]
		@showHash["pagename"] = issueCodeToPagename(@showHash[:issue].code)
		filename = Scansheet.find(params[:id]).image.path.split("/").last 
  		path = "/assets/uploads/scansheet/image/#{params[:id]}/#{filename}"
  		@showHash["path"] = path
  		@scansheet = Scansheet.find(@showHash[:issue].row_id)
  		@showHash["scansheet"] = @scansheet
  		ambigAnswers = @scansheet.ambiguous_answers.split("~")
  		ambigHash = Hash.new
  		ambigAnswers.each { |amb|
  			astr = amb.split(",")
  			k = Integer(astr[0])
  			v = astr[1,astr.size-1]
  			ambigHash[k] = v
  		}
  		@showHash["ambiguous_answers"] = ambigHash
		@showHash
	end


	def doAnswerverify
		# TODO function to make necessary changes
	end

	def prepNameverify
		@showHash = Hash.new()
		@showHash["issue"] = params[:issue]
		@showHash["pagename"] = issueCodeToPagename(@showHash[:issue].code)
		filename = Scansheet.find(params[:id]).image.path.split("/").last 
  		path = "/assets/uploads/scansheet/image/#{params[:id]}/#{filename}"
  		@showHash["path"] = path
  		@showHash
	end

end
