class AddIdToScansheet < ActiveRecord::Migration
  def change
    add_column :scansheets, :assignment_id, :integer
  end
end
