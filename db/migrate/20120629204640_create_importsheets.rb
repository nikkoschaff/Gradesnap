class CreateImportsheets < ActiveRecord::Migration
  def change
    create_table :importsheets do |t|
      t.string :datafile
      t.string :name
      t.integer :course_id
      t.timestamps
    end
  end
end
