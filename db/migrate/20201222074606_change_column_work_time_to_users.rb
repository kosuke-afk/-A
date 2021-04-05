class ChangeColumnWorkTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :work_time, :time
    change_column :attendances, :finish_time, :time
  end
end
