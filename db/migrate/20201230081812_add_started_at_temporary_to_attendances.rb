class AddStartedAtTemporaryToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :started_at_temporary, :datetime
    add_column :attendances, :finished_at_temporary, :datetime
  end
end
