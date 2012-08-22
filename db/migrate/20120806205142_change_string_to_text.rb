class ChangeStringToText < ActiveRecord::Migration
  def up
    change_column :assignments, :answer_key, :text , :limit => nil
    change_column :assignments, :name, :text, :limit => nil
	change_column :assignments, :answer_scansheet, :text, :limit => nil
	change_column :assignments, :email, :text, :limit => nil

	change_column :scansheets, :ambiguous_answers, :text, :limit => nil
	change_column :scansheets, :name, :text, :limit => nil
	change_column :scansheets, :answers_string, :text, :limit => nil
	change_column :scansheets, :assignment_student_id, :text, :limit => nil


	#remove_index :assignments_students, :results
	change_column :assignments_students, :results, :text, :limit => nil
	#add_index :assignments_students, :results, :name => "results"

	#remove_index :assignments_students, :answer_key
	change_column :assignments_students, :answer_key, :text, :limit => nil
	#add_index :assignments_students, :answer_key, :name => "answer_key"

	#change_column :assignments_students, :results, :text, :limit => nil
	#change_column :assignments_students, :answer_key, :text,  :limit => nil

  end

  def down
  	#remove_index(:assignment_students, :name => "add_index_to_assignment_students")
  end
end
