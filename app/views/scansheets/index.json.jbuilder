json.array!(@scansheets) do |json, scansheet|
  json.name scansheet.read_attribute(:image)
  json.size scansheet.image.size
  json.url scansheet.image.url
  json.thumbnail_url scansheet.image.thumb.url
  json.delete_url scansheet_path(:id => id)
  json.delete_type "DELETE"
end
