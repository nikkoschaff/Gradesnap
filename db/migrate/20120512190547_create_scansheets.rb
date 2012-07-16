class CreateScansheets < ActiveRecord::Migration
  def self.up
	create_table :scansheets do |t|
		t.column :name, :string
		t.column :ambiguous_answers, :string
		t.column :answers_string, :string
		t.column :assignment_student_id, :string

		t.timestamps
	end
  end

  def self.down
	drop_table :scansheets
  end

end
