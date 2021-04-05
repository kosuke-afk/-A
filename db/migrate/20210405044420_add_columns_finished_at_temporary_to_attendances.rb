class AddColumnsFinishedAtTemporaryToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :finished_at_temporary, :timestamp
    add_column :attendances, :started_at_temporary, :timestamp
  end
end
