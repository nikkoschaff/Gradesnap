module StatsHelper

	### STATISTICS FUNCTIONS ###

  # Mean - Adds the total of all grades given and returns the mean
  # Param: Grades - array<double> of grades
  # Return: Double - mean of the grades
  def mean( grades )
    grades.delete(nil)
    if grades == [] then
      return 0.0
    end
    total = 0.0
    grades.each { |grade| total += grade }
    total/grades.size
  end


  # Median - Returns the median value of grades given
  # Param: Grades - array<double> of grades
  # Return: Double - median of the grades
  def median( grades ) 
    grades.delete(nil)    
    if grades == [] then
      return 0.0
    end    
    grades.sort
    grades[ (grades.size / 2) ]
  end


  # Mode - Returns the mode of the given array of grades
  # Param: Grades - array<double> of grades
  # Return: Array - mode of the grades (frequency => grade)
  def mode( grades )
    grades.delete(nil)    
    if grades == [] then
      return 0.0
    end
    reqGradeArray = Hash.new()
    freq = 0
    freqGrade = 0.0

    # Record frequency for each grade
    grades.each{ |grade|
    # if !reqGradeArray.has_key?(grade)
    #   reqGradeArray.merge!({grade => 1})
    #  else
        
      reqGradeArray.include?(grade) ? reqGradeArray[grade] += 1 : (reqGradeArray[grade] = 1)
    }
   #     Rails.logger.info("  asdf3 #{reqGradeArray}" )
    # find the most frequent grade
    reqGradeArray.each{ |key, value|
      if value > freq then
        freqGrade = key
        freq = value
      end
    }
    returnArray = Array.new
    returnArray.push(freq)
    returnArray.push(freqGrade)
    return returnArray
  end
  
end

  # gradeDistribution - Returns a hash with the distribution for A-F grades
  # Param: Grades - array<double> of grades
  # Preturn: Array - the distribution for each grade
  def gradeDistribution( grades )
    # replace the following line with whatever gets a desired array of numerical grades
    gradeDistArray = { "A" => 0, "B" => 0, "C" => 0, "D" => 0, "F"=> 0 }
    gradeLetter = ""

    grades.each{ |grade| 
      gradeLetter = getGradeLetter( grade )
      gradeDistArray[gradeLetter] += 1
    }
    return gradeDistArray
  end



  # AnswerAccuracy - Find the average score for each question for each student
  # => in the array, compared to the key string
  # Param: StudentStringArray - The array of each student's answers
  # Param: KeyString - The string of the answer key
  # Return: Array - Accuracy (Index => Accuracy)
  def answerAccuracy( studentStringArray, keyString )
    keyAnsArr = formatAnswersFromSimple( keyString )
    # num of questions on the exam
    numQ = keyAnsArr.size
    accuracyArray = Array.new( )

    numQ.times do
      accuracyArray.push(0.0)
    end

    # For each student
    studentStringArray.each { |studentString|
      studentAnsArr = formatAnswersFromSimple( studentString )
      # For each question on the exam
      #for i in numQ
      counter = 0
      numQ.times do
        # Adds the correctness value to the array at that location
        accuracyArray[counter] += gradeQuestion( studentAnsArr[counter], keyAnsArr[counter] )
        counter += 1
      end
    }

    # Finds mean score for each question for every student
    numStudents = studentStringArray.size
    count = 0
    accuracyArray.size.times do
      accuracyArray[count] = accuracyArray[count] / numStudents
      count += 1
    end
    accuracyArray
  end

  # findIncorrectAccuracies - Find the incorrect accuracy for each Question
  # => For each student in the array, compared to the key string
  # => in the array, compared to the key string
  # Param: StudentStringArray - The array of each student's answers
  # Param: KeyString - The string of the answer key
  # Return: Array<Hash> - Incorrect Accuracy [for each q] (Choice => Frequency)   
  def findIncorrectAccuracies( studentStringArray, keyString )
    keyAnsArr = formatAnswersFromSimple( keyString )
    numQ = keyAnsArr.size
    incAccuracyArray = Array.new()
    result = Array.new()
    counter = 0
    
    numQ.times do
      incAccuracyArray[counter] = Hash.new()
      counter += 1
    end

    studentStringArray.each{ |studentString|
      studentAnsArr = formatAnswersFromSimple( studentString )
      counter = 0
      incAccuracyArray.each { |question|
      studentAnswer = studentAnsArr[counter]
      keyAnswer = keyAnsArr[counter]
      if gradeQuestion( studentAnswer, keyAnswer ) == 0 then
        if question.has_key?( studentAnswer )  then
          question[studentAnswer] += 1.0
        else
          question[studentAnswer] = 1.0
        end
      end
      counter += 1 
      }
    }
    incAccuracyArray
  end

  # incorrectAnswerAccuracy - Returns each most-chosen wrong answer with 
#frequency
  # => For each student in the array, compared to the key string
  # => in the array, compared to the key string
  # Param: StudentStringArray - The array of each student's answers
  # Param: KeyString - The string of the answer key
  # Return: Array - Incorrect Accuracy (Index => Incorrect Accuracy)  
  def incorrectAnswerAccuracy( studentStringArray, keyString )
    incAccuracyArray = findIncorrectAccuracies( studentStringArray, keyString )
    numStudents = studentStringArray.size
    # Array to return, answer[frequency]
    returnArray = Array.new()
    # go through each given answer for a question
    incAccuracyArray.each{ |question| 
      highestFreq = 0
      highestAnswer = Hash.new()
      question.each{ |key, value| 
        if(value > highestFreq) then
          highestFreq = value
          highestAnswer = key
        end
      }
      h = Hash.new 
      h[highestAnswer] = highestFreq / numStudents
      returnArray.push( h )
    }    
    returnArray
  end


  # StandardDeviation - Returns the standard deviation of values given
  # Param: Values - Array<double> - The numeric values to be tested
  # Return: Double - standard deviation
  def standardDeviation( values )
    sum = 0.0
    values.each { |value|
      sum += value
    }
    fMean = sum / values.size

    deviations = Array.new(0)
    values.each{ |value|
      dev = value - fMean
      deviations.push( dev * dev )
    }

    devSum = 0.0
    deviations.each{ |dev|
      devSum += dev
    }

    fVariance = devSum / (deviations.size - 1)
    return Math.sqrt(fVariance)
  end

  # getGradeLetter - Return the grade letter associated with the score
  # Param: type grade   Numeric grade value
  # Return:  string  Grade letter 
  def getGradeLetter(grade)
    if grade >= 0.9 && grade <= 1.0 then
      "A"
    elsif grade >= 0.8 && grade < 0.9 then
      "B"
    elsif grade >= 0.7 && grade < 0.8 then
      "C"
    elsif grade >= 0.6 && grade < 0.7 then
      "D"
    else
      "F"
    end
  end

### FORMATTING FUNCTIONS ###


  # formatAnswersFromSimple - Returns a vector of answers from the
  # simple format of strings
  #
  # Param: answerString - simple-formatted string of question/answers
  # Return: array<string> - Array of simple-format answers
  #
  def formatAnswersFromSimple( answerString )
    answerArr = []
    subAnsString = answerString.split( "~" )
    subAnsString.each{ |ansStr|
      answerArr.push( ansStr.split( "," ))
    }
      answerArr
  end

  # Return an array of only filled values from an answer array (string)
  def formatAnswerFromArray( answerString )
    answerRows = answerString.split("~")
     answerArr = Array.new()
     answerRows.each { |ans|
        row = ""
        ansarr = ans.split(",")
        ansarr.each { |a|
          row += a unless a == ","
        }
        answerArr.push(row)
     } 
     answerArr
  end


  # formatAnswersToSimple - Returns a string of simple format answers for DB
  # Simple format - answers delimited by commas
  # Ex: a,b,ac,de
  #
  # Param: answerArr - Array of answers
  # Return: string - Simple format of answers for DB
  #
  def formatAnswersToSimple( answerArr )
      answerArr.join("~")
  end


### GRADING FUNCTIONS ###

 # Grades every student according to the keyString, returns array of grades
 # Param: studentArr - Array of student results (alphabetical)
 # Param: keyString  - String of the assignment key (alphabetical)
 # Return: Array - Array of grades for each student
 def gradeAll( studentArr, keyString )
    grades = []
      studentArr.each { |studentString |
          grades.push( gradeStudent( studentString, keyString ) )
      }
      grades
  end


  # Grades a student according to the keyString, returns grade
  # Param: studentString - String of student results (alphabetical)
  # Param: keyString  - String of the assignment key (alphabetical)
  # Return: double - Grade of the student
  def gradeStudent( studentString, keyString )
    # Number of correct answers
    numCorrect = 0.0
      studentAnsArr = formatAnswersFromSimple( studentString )
      keyArr = formatAnswersFromSimple( keyString )
  count = 0
      studentAnsArr.each { |sarr|
          numCorrect = numCorrect + gradeQuestion( sarr, keyArr[count] )
  count += 1
      }
      numCorrect / studentAnsArr.size
  end


  # gradeQuestion - Grades a single (string-format) question against key
  # Param: studentAns - String of a single answer for a question (alphabetical)
  # Param: keyAns - String of a single correct answer for a question
  # Return: double - score (1 or 0)
  def gradeQuestion(studentAns, keyAns )
    # Value of correctness
      score = 0
      if studentAns == keyAns  then
          score = 1
      end
      score
  end

  
  # unreadableFiles - Returns a hash of all files that could not be read
  # Param: Assignment - Assignment that has been read (as self)
  # Return: Hash, :filename => error_code
  def unreadableFiles( assignment )
    unreadables = Hash.new()
    allSheets = Scansheet.where("assignment_id=?", assignment.id ).to_a
    allAssignmentStudents = AssignmentStudents.where("assignment_id=?", assignment.id).to_a
    gradedSheets = Array.new()
    allAssignmentStudents.each{ |student|
      gradedSheets.push(student.scansheet_id)
    }
    allSheets.each { |sheet|
      unless gradedSheets.include?(sheet.id) then
        unreadables[fname(sheet.image.path)] = sheet.answers_string
      end
    }
    unreadables
  end

  # Returns a hash of error codes and their conditions
  # Error code 1 - Image could not be loaded
  # Error code 2 - Unable to find calibration points
  # Error code 3 - Unable to calibrate image
  # Error code 4 - Calibration produced unreadable image  
  def errorsHash
    errHash = Hash.new()
    errHash["-1.0"] = "Error code 1 - Unable to find calibration points"
    errHash["-2.0"] = "Error code 2 - Unable to find calibration points"
    errHash["-3.0"] = "Error code 3 - Unable to calibrate image"
    errHash["-4.0"] = "Error code 4 - Calibration produced unreadable image"
    errHash
  end

  # Returns a base filename from the path
  def fname(path)
    path.split("/").last
  end


