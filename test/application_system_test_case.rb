require_relative "test_helper"

# CIでは webdrivers の自動DLが事故るので止める（Actions側でchromedriverを入れる前提）
if ENV["CI"] == "true"
  begin
    require "webdrivers"
    # 自動更新/自動DLを止める（webdrivers 5系）
    Webdrivers::Chromedriver.update = false if Webdrivers::Chromedriver.respond_to?(:update=)
    # 念のためキャッシュも長めに（任意）
    Webdrivers.cache_time = 86_400 if Webdrivers.respond_to?(:cache_time=)
  rescue LoadError
    # webdrivers を読み込めなければ無視
  end
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 390, 844 ]
end
