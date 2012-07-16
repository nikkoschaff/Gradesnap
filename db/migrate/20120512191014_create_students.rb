class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.integer :course_id
      t.float :grade	

      t.timestamps
    end
  end
end
