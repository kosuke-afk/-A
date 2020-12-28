module AttendancesHelper
  
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
