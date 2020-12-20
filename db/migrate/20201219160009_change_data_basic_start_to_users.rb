class ChangeDataBasicStartToUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :basic_start, :time
    change_column :users, :basic_finish, :time
  end
end
