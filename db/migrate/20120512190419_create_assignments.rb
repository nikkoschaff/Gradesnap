class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :num_questions
      t.string :answer_key
      t.string :name
      t.string :answer_scansheet
      t.string :email
      t.integer :course_id
      
      t.timestamps
    end
  end
end
