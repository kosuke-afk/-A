class RenameTypeColomnToBases < ActiveRecord::Migration[5.1]
  def up
    rename_column :bases, :type, :kind
  end
  def down
    rename_column bases, :kind, :type
  end
end
