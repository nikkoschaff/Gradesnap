# Class handles EXPORTING spreadsheets
#
class Exportsheet < ActiveRecord::Base
  attr_accessible :grade, :student, :assignment_id


  def self.to_csv(options = {})
    CSV.generate(options) do |csv_row|
      csv_row << column_names[1..2]
      all.each do |exportsheet|
	nextrow = exportsheet.attributes.values_at(*column_names)[1..2]
	csv_row << nextrow
      end
    end
  end


end
