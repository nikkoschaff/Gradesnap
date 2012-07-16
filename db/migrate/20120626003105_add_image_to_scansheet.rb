class AddImageToScansheet < ActiveRecord::Migration
  def change
    add_column :scansheets, :image, :string
  end
end
