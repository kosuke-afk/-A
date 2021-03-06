module AttendancesHelper
  $confirmation = %w{ 申請中 承認 否認 なし}
  $year = %w{2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025}
  $month = %w{01 02 03 04 05 06 07 08 09 10 11 12}
  def attendance_state(attendance)
    if Date.current == attendance.worked_on
      return "出勤" if attendance.started_at.nil?
      return "退勤" if attendance.started_at.present? && attendance.finished_at.nil?
    end
    return false
  end
    

  def working_times(start,finish)
    format("%.2f", (((finish - start) / 60) / 60.0)) # 時間の計算は秒数で行われるから、/60で時間に戻している。
  end
  
  def working_over_time(attendance,finish,basic)
    if attendance.next_day == 1
      format("%.2f", (((finish - basic + 24.hour) /60) / 60.0))
    elsif attendance.next_day == 0
      format("%.2f", (((finish - basic   ) / 60) / 60.0))
    end
  end
  
  def attendance_value_started(attendance)
    return "#{attendance.started_at.floor_to(15.minutes).strftime("%H:%M")}" if attendance.started_at.present?
  end
  
  def attendance_value_finished(attendance)
    return "#{attendance.finished_at.floor_to(15.minutes).strftime("%H:%M")}" if attendance.finished_at.present?
  end
  
  
 
  
end
