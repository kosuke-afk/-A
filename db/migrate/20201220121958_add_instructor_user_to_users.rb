class AddInstructorUserToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :instructor_user, :boolean, default: false
  end
end
