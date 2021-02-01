class CreateMonths < ActiveRecord::Migration[5.1]
  def change
    create_table :months do |t|
      t.string :one_month_instructor
      t.string :one_month_confirmation
      t.boolean :one_month_change
      t.integer :year
      t.integer :month
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
