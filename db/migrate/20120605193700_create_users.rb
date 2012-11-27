class CreateUsers < ActiveRecord::Migration
  def change
  	create_table :users do |t|
      t.column :name,             :string
  		t.column :hashed_password,  :string
  		t.column :email,            :string
  		t.column :salt,             :string
      t.column :teacher_id,       :integer
      t.timestamps
	end
  end
end
