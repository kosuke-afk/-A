class RemoveOneMonthInstructorFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :one_month_instructor, :string
    remove_column :attendances, :one_month_check, :integer
  end
end
