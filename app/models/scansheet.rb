class Scansheet < ActiveRecord::Base
	include Rails.application.routes.url_helpers
	mount_uploader :image, ImageUploader
	
	# answer string is a read-results-style string, ie mae of floats
	# name is a read-results-style string of the name
	# ambig_ans is a read-results-style string for all ambiguous answers
	attr_accessible :answers_string, 
              		:name, 
              		:ambiguous_answers,
              		:image,
              		:image_cache,
              		:assignment_id,
                  :issues,
                  :issues_attributes


	belongs_to :assignments_student
  belongs_to :assignment, :foreign_key => ":assignment_id"

  has_many :issues, :dependent => :destroy
  accepts_nested_attributes_for :issues, :allow_destroy => :true

  validates :image, :presence => true
  
  def to_jq_upload
    {
      "name" =>  read_attribute(:image),
      "size" => image.size,
      "url" => image.url,
      "delete_url" => scansheet_path(:id => id),
      "delete_type" => "DELETE" 
    }
  end


### NUMERIC VALUE TRANSLATION FUNCTIONS ###

  # filled? - Tells whether an answer was answered or not
  #
  # Param: value - The numeric value of the region's fill
  # Return: bool - Whether it was filled or not
  #
  def filled?( value )
      #TODO make ML component to adjust thresholdValue
      thresholdValue = 0.4;
      value > thresholdValue ? true : false
  end


  # translateFromFillValue - Get the letter from the fill value
  #
  # Param: value - The numeric value of the region's fill
  # Param: index - The index from which it was found (0-25)
  # Return: string - The string value of the resultant bubble
  #
  def translateFromFillValue( value, index )
    filled?(value) ? (('a'..'z').to_a[index]) : (" ")
  end


  # translateAnswerRow - Get the full set of letters from an answer row fill
  #
  # Param: valArr - The array of fill values
  # Return: string - The string value of the answer row
  #
  def translateAnswerRow( valArr )
    valStr = ""
    index = 0
    valArr.each { |value|
      valStr += ( translateFromFillValue( value, index ) + "," )
      index = index + 1
    }
    valStr
  end


  # translateAllAnswers - Get the full set of answers from each row fill
  #
  # Param: completeFillArr - The array of strings each containing fill values
  # Return: array - The array of letter values
  #
  def translateAllAnswers( completeFillArr )
    ansArr = []
    completeFillArr.each { |fillArr|
      ansArr.push( [translateAnswerRow( fillArr )] )
    }
    ansArr
  end


  #
  # translateName - Get the name from the string of fill values
  #
  # Param: nameValArr - The array containing name fill values
  # Return: string - The resultant name from the read
  #
  def translateName( nameValArr )
    name = ""
    nameValArr.each { |nameVal|
      index = nameVal.floor
      val = nameVal - index
      name = name + translateFromFillValue( val, index )
    }
    newName = (name[0..7] + "," + name[8] + "," + name[9..16])
    newName
  end


  # formatNameFromString - Splits the name by delimiter value (",")
  # Param: name - String of the name, DB-formated 
  # Return: array - String array of the first, middle, and last name
  def formatNameFromString( name )
    name.split(",")
  end

### Ambiguous Answer Handling ###

  def ambiguous?( value )
      #TODO make ML component to adjust thresholdValue
      high = 0.45
      low = 0.35
      (value > low and value < high) ? true : false
  end

  # translateFromFillValue - Get the letter from the fill value
  #
  # Param: value - The numeric value of the region's fill
  # Param: index - The index from which it was found (0-25)
  # Return: string - The string value of the resultant bubble
  #
  def translateFromAmbigValue( value, index )
    ambiguous?(value) ? (('a'..'z').to_a[index]) : ("")
  end

  # translateAmbigRow - Get the full set of letters from an ambig row fill
  #
  # Param: valArr - The array of fill values
  # Return: string - The string value of the answer row
  #
  def translateAmbigRow( valArr )
    valStr = ""
    index = 0
    valArr.each { |value|
      valStr += ( translateFromAmbigValue( value, index ) )
      index = index + 1
    }
    valStr
  end


  # TranslateAmbig - Get ambiguous answers from string of fill values
  #
  def translateAllAmbig( completeFillArr )
    ambigStr = ""
    ansArr = []
    index = 0
    completeFillArr.each { |fillArr|
      result = translateAmbigRow( fillArr )
      unless result == "" then
        ansArr.push( "#{index} #{result}" )
      end
      index += 1
    }
    ambigStr = ansArr.join("~")
    ambigStr
  end

end

