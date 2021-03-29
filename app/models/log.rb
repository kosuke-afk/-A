class Log < ApplicationRecord
   belongs_to :attendance
   scope :worked_on_between, -> from, to { where(attendances: {worked_on: from..to})}
   scope :attendance_logs_for, -> user_id {
       joins(:attendance).where(attendances: {user_id: user_id})}
end
