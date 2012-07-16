class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.datetime :created_at
      t.integer :teacher_id
      t.timestamps
    end
  end
end
