module CalendarHelper
  require "holiday_jp"

  # 土日祝日のクラス名を返す
  def day_text_color(date)
    if date.sunday? || HolidayJp.holiday?(date)
      "text-red-500"
    elsif date.saturday?
      "text-sky-500"
    else
      "text-gray-800"
    end
  end
end
