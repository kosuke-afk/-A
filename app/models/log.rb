class Log < ApplicationRecord
  belongs_to :attendance
  scope :worked_on_between, -> from, to { where(worked_on: from..to) }
  scope :attendance_logs_for, -> user_id {
    joins(:attendance).where(attendances: {user_id: user_id})
  }
  
  # def self.search(year,month,id)
  #   if year
  #     Log.joins(:attendance).where(["worked_on Like ?", year],attendances: {user_id: id})
  #   elsif year && month
  #     Log.joins(:attendance).where(['worked_on Like ?', year, month], attendances: {user_id: id})
  #   else
  #     Log.joins(:attendance).where(attendances: {user_id: id})
  #   end
  # end
end
