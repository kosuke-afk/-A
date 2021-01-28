class AddOneMonthInstructorToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :one_month_instructor, :string
    add_column :attendances, :one_month_check, :integer
  end
end
