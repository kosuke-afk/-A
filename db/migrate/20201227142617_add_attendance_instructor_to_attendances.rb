class AddAttendanceInstructorToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :attendance_instructor, :string
    add_column :attendances, :attendance_change, :boolean
    add_column :attendances, :attendance_confirmation, :string
  end
end
