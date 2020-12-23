class RemoveBasicTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :basic_time, :datetime
    change_column :users, :work_time, :time, default: "22:30:00"
    change_column :attendances, :finish_time, :time
  end
end
