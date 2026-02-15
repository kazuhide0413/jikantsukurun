# test/application_system_test_case.rb
require "test_helper"
require "selenium/webdriver"

# CIでは、Actionsでインストールしたchromedriverを確実に使う
if ENV["CI"]
  Selenium::WebDriver::Chrome::Service.driver_path = `which chromedriver`.strip
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome do |options|
    # CIでChromeが落ちやすいのを防ぐ定番オプション
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-gpu")
    options.add_argument("--window-size=1400,1400")
  end
end
