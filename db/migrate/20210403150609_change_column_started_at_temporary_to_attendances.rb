class ChangeColumnStartedAtTemporaryToAttendances < ActiveRecord::Migration[5.1]
  def up
    change_column :attendances, :started_at_temporary, :datetime
    change_column :attendances, :finished_at_temporary, :datetime
  end
  
  def down
    change_column :attendances, :started_at_temporary, :time
    change_column :attendances, :finished_at_temporary, :time
  end
end
