class RenameColomnWorkTimeToUsers < ActiveRecord::Migration[5.1]
  def up
    rename_column :users, :work_time, :basic_work_time
    rename_column :users, :basic_start, :designated_work_start_time
    rename_column :users, :basic_finish, :designated_work_end_time
  end
  
  def down
    rename_column :users, :basic_work_time, :work_time
    rename_column :users, :designated_work_start_time, :basic_start
    rename_column :users, :designated_work_end_time, :basic_finish
  end
end
