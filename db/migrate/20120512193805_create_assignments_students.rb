class CreateAssignmentsStudents < ActiveRecord::Migration
  def change
    create_table :assignments_students do |t|
      t.integer :assignment_id
      t.integer :student_id
      t.integer :scansheet_id
      t.float :grade
      t.text :results, :limit => nil
      t.text :answer_key, :limit => nil

      t.timestamps
    end

    add_index :assignments_students, :assignment_id
    add_index :assignments_students, :student_id
    add_index :assignments_students, [:assignment_id, :student_id], unique: true    
  end
end
