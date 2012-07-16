# encoding: utf-8
require 'docsplit'

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  
  # Override the directory where uploaded files will be stored.
  def store_dir
    "#{Rails.root}/app/assets/images/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    "/public/img.jpg"
  end

  def extension_white_list
    %w(jpg jpeg gif png pdf tif tiff bmp)
  end

  ### FILE FORMAT ###

  # numPages - Returns the number of pages in the image
  #
  # Param: image - Image with unknown page count
  # Return: integer - number of pages in the image
  def numPages( image )
    img = MiniMagick::Image.open(image.path)
    Integer(img["%n"])
  end

  # splitMultiPage - Splits a multi-page image into readable images
  # => Creates scansheets for them, and deletes all traces of unusable image
  # Param: multiPageSheet - Scansheet with multiple pages
  # Param: assignmentID - ID of current assignment, used to link new Scansheet
  # Param: num_pages - Number of pages in the multiPageSheet
  # Return: array<Sheet> - Array of new Scansheets
  def splitMultiPage( multiPageSheet, assignmentID, num_pages )
    newSheets = Array.new()
    pg = 1
    oldPath = multiPageSheet.image.path
    pathDir = oldPath.split("/")
    pathDir.pop
    pathDirStr = pathDir.join("/")
    pathDirStr += "/"

    #Change directory to the path.  Needed for docsplit or else
    #it extracts to the current directory (rails root by default)
    Dir.chdir(pathDirStr)
    Docsplit.extract_images(oldPath, :format => [:jpg])

    num_pages.times do
      newSheet = Scansheet.new
      newPathArr = oldPath.split(".")
      newPathStr = "#{newPathArr[0]}_#{pg}.jpg"
      newSheet.image = File.open(newPathStr)
      newSheet.assignment_id = assignmentID
      newSheet.save
      newSheets.push( newSheet )
      pg += 1
    end
    #Scansheet.destroy( multiPageSheet )
    Dir.chdir(Rails.root)
    newSheets
  end

  # goodImageFormat? - Checks to see if the format was readable.
  # => If so, returns true. Otherwise, false
  #
  # Param: scansheet - Scansheet with unknown extension type
  # Return: bool - Whether the image is readable or not
  #
  def goodImageFormat?( path )
    supported = ["bmp", "jpeg", "jpg",
      "png", "tiff", "tif" ]
    pathArray = path.split(".")
    extension = pathArray.last.downcase
    supported.include?(extension) ? true : false
  end

  # setGoodImageFormat - Changes image to a readable jpeg extension
  def setGoodImageFormat(sheet)
    oldPath = sheet.image.path
    pathArray = oldPath.split(".")
    pathArray.pop
    pathArray.push( "jpg" )
    newPath = pathArray.join(".")
    img = MiniMagick::Image.open(oldPath)
    img.format "jpg"
    img.write(newPath)
    img.path = newPath
    File.delete(oldPath)
    img
  end

end
