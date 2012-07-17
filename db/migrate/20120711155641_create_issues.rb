class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :code
      t.integer :teacher_id
      t.string :tablename
      t.integer :row_id
      t.boolean :resolved
      t.string :name

      t.timestamps
    end
  end
end
