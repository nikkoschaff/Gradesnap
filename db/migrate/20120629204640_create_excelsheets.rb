class CreateExcelsheets < ActiveRecord::Migration
  def change
    create_table :excelsheets do |t|
      t.string :datafile
      t.string :name
      t.timestamps
    end
  end
end
