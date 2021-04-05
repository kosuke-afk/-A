class ChangeColumnFinishedAtTemporaryToAttendances < ActiveRecord::Migration[5.1]
  def up
    change_column :attendances, :started_at_temporary, :timestamp
    change_column :attendances, :finished_at_temporary, :timestamp
    add_column :users, :ab, :string
  end
  
  def down
    change_column :attendances, :started_at_temporary, :datetime
    change_column :attendances, :finished_at_temporary, :datetime
  end
end
