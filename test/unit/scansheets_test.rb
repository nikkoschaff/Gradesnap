require 'test_helper'

class ScansheetsTest < ActiveSupport::TestCase

## filled? ##

test "filled? should reject low threshold value as filled" do
	assert !filled?(0.4)
end

test "filled? should accept minimum threshold value as filled" do
	assert filled?(0.041)
end

## translateFromFillValue ##

test "translateFromFillValue should say 'e'" do
	assert translateFromFillValue( 0.5, 4 ) == 'e'
end

test "translateFromFillValue should be blank" do
	assert translateFromFillValue( 0.3, 0 ) == " "
end

## tranlsateAnswerRow ##

test "translateAnswerRow should translate row to 'a c e'" do
	ansRow = [0.5, 0.3, 0.5, 0.3, 0.5]
	assert translateAnswerRow( ansRow ) == "a, ,c, ,e,"
end

## translateAllAnswers ##

test "translateAllAnswers should have two rows: '[a, ,c, ,e],[ ,b, ,d, ]'" do
	ansRow1 = [0.5, 0.3, 0.5, 0.3, 0.5]
	ansRow2 = [0.3, 0.5, 0.3, 0.5, 0.3]
	rows = [ansRow1,ansRow2]
	ans = translateAllAnswers( rows )
	assert (ans[0] == "a, ,c, ,e," and ans[1] == " ,b, ,d, ,")
end

## translateName ##

test "translateName name should be: 'john    ,j,glynn   " do
	nameArr = [[9.5,14.5,7.5,13.5,0.2,0.2,0.2,0.2],[9.5],[6.5,11.5,24.5,13.5,13.5,0.2,0.2,0.2]]
	assert (translateName( nameArr ) == 'john    ,j,glynn   ')
end

## translateAmbig ##
## TODO 

## formatAnswersFromSimple ##

test "formatAnswersFromSimple should have two rows:'a, ,c, ,e,~ ,b, ,d, ,~'" do
	ansString = 'a, ,c, ,e,~ ,b, ,d, ,~'
	ansArr = formatAnswersFromSimple( ansString )
	assert (ans[0] == "a, ,c, ,e," and ans[1] == " ,b, ,d, ,")
end


## formatAnswersToSimple ##


#test "formatAnswersToSimple should translate to "


## formatNameFromString ##


## formatNameForCompare ##


## findStudentFromNAme ##


## beginRead ##


## organizeDecResults ##

## isKeyImage? ##

## setFilePath ##


## multiPatge? ##

## goodImageFormat? ##


## splitMultiPage ##


## setGoodImageFormat ##


end
