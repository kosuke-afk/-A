class RemoveStartedAtTemporaryToAttendances < ActiveRecord::Migration[5.1]
  def up
    remove_column :attendances, :started_at_temporary, :datetime
    remove_column :attendances, :finished_at_temporary, :datetime
  end
  
  def down
    add_column :attendances, :started_at_temporary, :datetime
    add_column :attendances, :finished_at_temporary, :datetime
  end
end
