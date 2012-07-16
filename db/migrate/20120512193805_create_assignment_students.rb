class CreateAssignmentStudents < ActiveRecord::Migration
  def change
    create_table :assignment_students do |t|
      t.integer :assignment_id
      t.integer :student_id
      t.integer :scansheet_id
      t.float :grade
      t.string :results
      t.string :answer_key

      t.timestamps
    end

    add_index :assignment_students, :assignment_id
    add_index :assignment_students, :student_id
    add_index :assignment_students, [:assignment_id, :student_id], unique: true    
  end
end
