class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.date :worked_on
      t.time :before_started
      t.time :before_finished
      t.time :after_started
      t.time :after_finished
      t.string :instructor
      t.date :approval_day
      t.references :attendance, foreign_key: true

      t.timestamps
    end
  end
end
