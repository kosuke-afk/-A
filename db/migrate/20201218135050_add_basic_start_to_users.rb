class AddBasicStartToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :basic_start, :datetime
    add_column :users, :basic_finish, :datetime
  end
end
