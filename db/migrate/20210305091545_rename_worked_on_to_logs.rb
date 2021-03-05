class RenameWorkedOnToLogs < ActiveRecord::Migration[5.1]
  def up
    rename_column :logs, :worked_on, :log_worked_on
  end
  def down
    rename_column :logs, :log_worked_on, :worked_on
  end
end
