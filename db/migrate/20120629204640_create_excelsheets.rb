class CreateExcelsheets < ActiveRecord::Migration
  def change
    create_table :excelsheets do |t|
      t.string :datafile

      t.timestamps
    end
  end
end
