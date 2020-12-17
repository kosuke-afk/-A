class AddColumnsToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :finish_time, :datetime
    add_column :attendances, :aim, :string
  end
end
