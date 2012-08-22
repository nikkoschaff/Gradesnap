class Importsheet < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  mount_uploader :datafile, DatafileUploader

  attr_accessible :datafile, :name, :course_id

  #validates :name, :presence => true
  #validates :num_q, :presence => true

  validates :datafile, :presence => true



  #Function takes datafile and sets a number of students from it.
  def datafile_to_students(course)
    book = Spreadsheet.open self.datafile.path

    counter = 0
    sheet = book.worksheet counter
    if course
      unless sheet == nil
        sheet.each{ |row|
          s = Student.new( :first_name  => row[0],
                           :middle_name => row[1],
                           :last_name => row[2], 
                           :course_id => course,
			   :grade => 0.0)
          s.save
        }
      counter += 1
      sheet = book.worksheet counter
      end
    end
  end

  def to_jq_upload
      {
        "id" => read_attribute(:id),
        "name" =>  read_attribute(:datafile),
        "size" => datafile.size,
        "url" => datafile.url,
        "delete_url" => importsheet_path(:id => id),
        "delete_type" => "DELETE" 
      }
    end

end
