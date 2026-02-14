# frozen_string_literal: true

module DailySessionsHelper
  def effective_bg_class(minutes)
    m = minutes.to_i
    return "eff-bg-0" if m == 0
    return "eff-bg-1" if m <= 30
    return "eff-bg-2" if m <= 60
    return "eff-bg-3" if m <= 120
    "eff-bg-4"
  end
end
