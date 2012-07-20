class CreateExportsheets < ActiveRecord::Migration
  def self.up
    create_table :exportsheets do |t|
      t.string :student
      t.integer :grade
      t.integer :assignment_id

      t.timestamps
    end
  end

  def self.down
  	drop_table :exportsheets
  end
end
