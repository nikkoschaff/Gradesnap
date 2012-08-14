class AddSubscribedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscribed, :integer
  end
end
