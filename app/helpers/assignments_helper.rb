module AssignmentsHelper


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
      if( studentAns == keyAns ) then
          score = 1
      end
      score
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



  # formatAnswersToSimple - Returns a string of simple format answers for DB
  # Simple format - answers delimited by commas
  # Ex: a,b,ac,de
  #
  # Param: answerArr - Array of answers
  # Return: string - Simple format of answers for DB
  #
  def formatAnswersToSimple( answerArr )
    resultString = ""
  #  answerArr.each{ |ansArr|
#      resultString = resultString + ansArr.join( "," )
 #     resultString = resultString + "~"
  #  }
  resultString = answerArr.join("~")
end


  # formatNameFromString - Splits the name by delimiter value (",")
  # Param: name - String of the name, DB-formated 
  # Return: array - String array of the first, middle, and last name
  def formatNameFromString( name )
    name.split(",")
  end


  # Formats a given name (from the database)
  # => into form for comparing [First,MI,Last] with 
  # => 8-char max for first and last
  # Param: Name - string of the name, DB-formatted
  # Return: Array - String array of the first name, middle initial,
  # => And last name, with only first 8 chars for name,
  # => and any names shorter than 8 characters have white space added
  def formatNameForCompare( name ) 
    nameArr = formatNameFromString( name )

    firstName = nameArr[0]
    if ( firstName.size >= 8 ) then
      firstName = firstName[0-7]
    else
      sizeDiff = 8 - firstName.size
      firstName = firstName + " ".times(sizeDiff)
    end

    middleInitial = nameArr[1][0]

    lastName = nameArr[2]
    if( lastName.size >= 8 ) then 
      lastName = lastName[0-7]
    else 
      sizeDiff = 8 - lastName.size
      lastName = lastName + " ".times(sizeDiff)
    end
    formatName = [firstName, middleInitial, lastName]
    formatName
  end
  
  # findStudentFromName - Finds a match between names 
  # Param: Name - the [7][1][7] string (to array in method)
  # Param: Students - a hash of student names to students 
  # Return: Student/nil - Depending on find, returns the student, otherwise 
  def findStudentFromName( name, students )
    splitName = formatNameFromString( name )
    students.has_key?( splitName ) ? students[splitName] : nil
  end




	
end
