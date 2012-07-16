class Excelsheet < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  mount_uploader :datafile, DatafileUploader

  attr_accessible :datafile#, :name, :num_q

  #validates :name, :presence => true
  #validates :num_q, :presence => true

  validates :datafile, :presence => true

  def self.to_csv(options = {})
  	CSV.generate(options) do |csv|
  		csv << column_names
  		all.each do |product|
  			csv << product.attributes.values_at(*column_names)
  		end
  	end
  end

  #Function takes datafile and sets a number of students from it.
  def datafile_to_students
    book = Spreadsheet.open self.datafile.path

    counter = 0
    sheet = book.worksheet counter

    unless sheet == nil
      sheet.each{ |row|
        if str == row[0] && 
           str == row[1] && 
           str == row[2] then
          s = Student.new( :first_name  => row[0],
                           :middle_name => row[1],
                           :last_name => row[2], 
                           :course_id => @course.id)
          s.save
        end
      }
      counter += 1
      sheet = book.worksheet counter
    end
  end

  def to_jq_upload
      {
        "id" => read_attribute(:id),
        "name" =>  read_attribute(:datafile),
        "size" => datafile.size,
        "url" => datafile.url,
        "delete_url" => excelsheet_path(:id => id),
        "delete_type" => "DELETE" 
      }
    end

end
