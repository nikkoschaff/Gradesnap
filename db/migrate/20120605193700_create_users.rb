class CreateUsers < ActiveRecord::Migration
  def self.up
  	create_table :users do |t|
      t.column :name,             :string
  		t.column :hashed_password,  :string
  		t.column :email,            :string
  		t.column :salt,             :string
  		t.column :created_at,       :datetime
      t.column :teacher_id,       :integer
      t.column :confirmation_code, :string
      t.column :confirmed,         :boolean
  	end
  end

  def self.down
  	drop_table :users
  end
end
