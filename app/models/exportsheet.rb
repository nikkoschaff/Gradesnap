# Class handles EXPORTING spreadsheets
#
class Exportsheet < ActiveRecord::Base
  attr_accessible :grade, :student, :assignment_id


  def self.to_csv(options = {})
    CSV.generate(options) do |csv_row|
      csv_row << column_names
      all.each do |product|
        csv_row << product.attributes.values_at(*column_names)
      end
    end
  end


end
