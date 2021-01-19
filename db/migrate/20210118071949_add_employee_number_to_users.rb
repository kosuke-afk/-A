class AddEmployeeNumberToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :employee_number, :integer
    rename_column :users, :department, :affiliation
    rename_column :users, :instructor_user, :superior 
    change_column_default :users, :superior, false
  end
  
  def down
    rename_column :users, :affliation, :department
    rename_column :users, :superior, :instructor_user
    change_column_default :users, :instructor_user, false
  end
end
