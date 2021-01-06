module UsersHelper
  
  def format_basic_info(time)
    format("%.2f", ((time.hour * 60) + time.min) / 60.0)
  end
  
  def wday_class(day)
    if day.worked_on.wday == 0
      "danger"
    elsif day.worked_on.wday == 6
      "info"
    end
  end
  
end
