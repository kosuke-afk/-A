class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.date :log_worked_on
      t.time :before_started
      t.time :before_finished
      t.time :after_started
      t.time :after_finished
      t.string :log_instructor
      t.date :approval_day
      t.belongs_to :attendance, index: true, foreign_key: true
      t.timestamps
    end
  end
end
