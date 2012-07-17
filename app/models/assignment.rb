class Assignment < ActiveRecord::Base
  # answer_key is a results string, one big string
  # num_questions is the total number of questions
  #
  attr_accessible :email, 
                  :answer_key,
                  :answer_scansheet,
                  :num_questions,
                  :name,
                  :scansheets,
                  :scansheets_attributes,
                  :students,
                  :course_id


  # One scansheet (key)
  has_one :answer_scansheet, :class_name => "Scansheet", :dependent => :destroy

  # Nested many scansheets (students)
  has_many :scansheets, :dependent => :destroy
  accepts_nested_attributes_for :scansheets, :allow_destroy => true

  #many-many connection with students
  has_many :assignment_students, :foreign_key => ":assignment_id"
  has_many :students, :through => :assignment_students

  belongs_to :course, :foreign_key => ":course_id"
  belongs_to :user  

  #Validations
  validates :name, :presence => true
  validates :num_questions, :presence => true,
                            :inclusion => { :in => 1..100 },
                            :numericality => { :only_integer => true }
  validates :course_id, :presence => true


### READ INTERPRETATION FUNCTIONS ###

  # beginRead - Reads each, stores data accordingly (from data within model)
  # Return: Array<StudentAssignments> Returns the studentAssignments for each read
  def readImages( sheets )
    # List of file paths for each image file
    filenames = Array.new() 
    # The array of students in this course
    studentArray = Student.where("course_id=?", self.course_id ).to_a
    # Hash of :name => :student
    studentHashNames = Hash.new()
    studentArray.each { |s|
      studentHashNames[formatNameForCompare(s)] = s
    }
    badSheets = Array.new()

    # Generate additional sheets, if any were multi-page
    # Also turns unreadable (vector) images to readable (raster) images
    sheets.each { |sheet|
      num_pages = sheet.image.numPages(sheet.image)
      if num_pages > 1 then
        sheets += sheet.image.splitMultiPage( sheet, self.id, num_pages )
        badSheets.push( sheet )
      else 
        unless sheet.image.goodImageFormat?(sheet.image.to_s) then
          sheet.image = sheet.image.setGoodImageFormat(sheet)
          sheet.save
        end
      end
    }

    badSheets.each { |bad|
      Assignment.delete(bad.id)
      sheets.delete(bad)
      bad.destroy
    }

    sheets.each { |sheet|
      path = "#{sheet.image.to_s}"
      if ( File.exists?( path ) ) then 
        filenames.push( path )
      else 
        Rails.logger.info("*** No path found: #{path}")
      end
    } 

    #Calls image processing
    iproc = Imgproc.new
    decimalStudentResults = iproc.readFiles(filenames,Integer(self.num_questions),true)

    count = 0
    # Organizes the results for each student image
    decimalStudentResults.each { |decstu|
      unless ( decstu.last.last < 0 ) then
        organizeDecResults( decstu, studentHashNames, sheets[count] )
      else 
        sheets[count].answers_string = decstu.last.last
        sheets[count].save
      end
      count += 1
    }
  end


  # Organizes information for the imagefile
  # If a student could be found from the name, then it automatically creates the
  # => associative assignmentStudent with data filled in, then saves
  # If a student coult NOT be found from the name, then the same occurs except 
  # => instead of a given student, it will be a new student created with the name
  # => found on the test, linked to the assignment ONLY 
  # Param: decResults - The decimal results direct from the read
  # Param: studentHashNames - The hash of names to students to find from read
  # Param: sheet - the image being read from
  # Return: AssignmentStudent - The assignmentStudent generated with data filled
  # => (if everthing was properly found)
  def organizeDecResults( decResults, studentHashNames, sheet ) 
    # Find values for name and results
    decName = decResults.pop
    name = sheet.translateName( decName )
    strResults = formatAnswersToSimple( sheet.translateAllAnswers(decResults) )
    strAmbig = sheet.translateAllAmbig( decResults )
    sheet.ambiguous_answers = strAmbig
    unless strAmbig == "" then
      Rails.logger.info("&*(((*(^&(*^*^&(*&^*&^(&(*%&(*&%(^&(^&*^&*&^*^)))))))))))))}")
      course = Course.find(self.course_id)
      teacher_id = Teacher.find(course.teacher_id)
      ambigIssue = Issue.new( :code => 1, :resolved => false,
       :row_id => sheet.id, :tablename => "Scansheet", :teacher_id => teacher_id, 
       :name => "Ambiguous Answers" )
      ambigIssue.save
    end

    # Enter and save data for the sheet
    sheet.name = decName
    sheet.answers_string = decResults

    sheet.save
    # Find the student from the given students for a match
    theStudent = findStudentFromName( name, studentHashNames )
    grade = gradeStudent( strResults, self.answer_key )  
    # If found, then handle data from here.
    unless theStudent == nil then
      course = Course.find(self.course_id)
      teacher_id = Teacher.find(course.teacher_id)
      nameIssue = Issue.new( :code => 2, :resolved => false,
       :row_id => sheet.id, :tablename => "Scansheet", :teacher_id => teacher_id,
       :name => "Name Not Found" )
      nameIssue.save
      @newAssignmentStudent = AssignmentStudents.new({ :assignment_id => self.id,
        :student_id => theStudent.id, :scansheet_id => sheet.id,
        :grade => grade,:results => strResults, :answer_key => self.answer_key })
      theStudent.grade = theStudent.compileGrade
      theStudent.save
    else 
      nameArr = name.split(",")
      @newStudent = Student.new( :first_name => ("~" + nameArr[0]),
        :middle_name => ("~" + nameArr[1]), :last_name => ("~" + nameArr[2]), :grade => grade,
        :course_id => self.course_id )
      @newStudent.save
      @newAssignmentStudent = AssignmentStudents.new({ :assignment_id =>  self.id,
        :student_id => @newStudent.id, :scansheet_id => sheet.id, :grade => grade,
        :results => strResults, :answer_key => self.answer_key} )
    end
    @newAssignmentStudent.save
  end


  def readKey( sheet )
    keystr = ""
    scanarr = Array.new()    
    path = "#{sheet.image.to_s}"

    # Secures the key against unreadable files (pdf) by converting to jpeg
    unless sheet.image.goodImageFormat?(path) then
      sheet.image = sheet.image.setGoodImageFormat(sheet)
      sheet.save
      path = sheet.image.path
    end   

    if ( File.exists?( path ) ) then 
      scanarr.push(path)
    else 
      Rails.logger.info("*** No path found: #{path}")
      return keystr
    end   

    iproc = Imgproc.new
    decResultsArr = iproc.readFiles(scanarr,Integer(self.num_questions),false)
    decKey = decResultsArr.pop

    unless decKey.last == -1 then
      # pop "name". Though setting is "False", it still returns array for cleanliness
      decName = decKey.pop 
      sheet.name = sheet.translateName( decName )      
      strResults = sheet.translateAllAnswers(decKey).join("~")
      strAmbig = sheet.translateAllAmbig( decKey )
      unless strAmbig == "" then
        course = Course.find(self.course_id)
        teacher_id = Teacher.find(course.teacher_id)
        ambigIssue = Issue.new( :code => 1, :resolved => false,
         :row_id => sheet.id, :tablename => "Scansheet", :teacher_id => teacher_id,
         :name => "Ambiguous Answers" )
        ambigIssue.save
      end

      # Enter and save data for the sheet
      sheet.ambiguous_answers = strAmbig
      sheet.answers_string = decKey
      sheet.save
      self.answer_scansheet = sheet
      keystr = strResults
      self.answer_key = keystr
      self.save      
    end
    keystr
  end

### Name-finding and matching helpers ###

  # Formats a given name (from the database)
  # => into form for comparing [First,MI,Last] with 
  # => 8-char max for first and last
  # Param: Name - string of the name, DB-formatted
  # Return: Array - String array of the first name, middle initial,
  # => And last name, with only first 8 chars for name,
  # => and any names shorter than 8 characters have white space added
  def formatNameForCompare( student ) 
    firstName = student.first_name
    if ( firstName.size >= 8 ) then
      firstName = firstName[0..7]
    else
      sizeDiff = 8 - firstName.size
       str = ""
      sizeDiff.times do |sz|
        str += " "
      end
      firstName += str
    end

    middleInitial = student.middle_name.first

    lastName = student.last_name
    if( lastName.size >= 8 ) then 
      lastName = lastName[0..7]
    else 
      sizeDiff = 8 - lastName.size
      str = ""
      sizeDiff.times do |sz|
        str += ","
      end      
      lastName += str
    end
    formatName = (firstName + "," + middleInitial + "," + lastName)
    formatName
  end

  # findStudentFromName - Given a name from read and hash of name=>student,
  # => find the correct studennt, otherwise return nil
  # Param: Name - Name of the student from the sheet
  # Param: studentHashNames - Hash of name => student
  # Return: Student if true, otherwise nil
  def findStudentFromName( name, studentHashNames ) 
    student = nil
    if studentHashNames.include?( name ) then
      student = studentHashNames[name]
    end
    student
  end

  ### GETTER HELPERS ###

  def grades()
    all_ass_stdnts = AssignmentStudents.where(" assignment_id = ?", self.id)
    gradeArr = Array.new()
    all_ass_stdnts.each { |student|
      gradeArr.push(student.grade)
    }
    gradeArr
  end


  def studentStringArray()
    studentStringArray = Array.new
    all_ass_stdnts = AssignmentStudents.where("assignment_id=?", self.id)
    all_ass_stdnts.each{ |stdnt|
         studentStringArray.push(stdnt.results)
        }
    studentStringArray
  end

### View-rendering helpers ###
  
  # Prepares the show hash for assignment
  # Param: Assignment
  # Return: Hash for variables needed for the view
  def prepShowAssignment
    showHash = Hash.new()
    showHash[:assignment] = self
    showHash[:students] = Student.where("course_id=?",self.course_id)
    showHash[:assignmentstudents] = AssignmentStudents.where("assignment_id=?",self.id)
    showHash
  end

end
