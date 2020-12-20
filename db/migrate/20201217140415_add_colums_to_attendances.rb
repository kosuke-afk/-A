class AddColumsToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :next_day, :integer
    add_column :attendances, :instructor, :string
    add_column :attendances, :instructor_confirmation, :string
  end
end
