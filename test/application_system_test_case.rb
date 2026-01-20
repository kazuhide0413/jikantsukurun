require_relative "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 390, 844 ], options: {
    browser: :chrome,
    args: %w[
      no-sandbox
      disable-dev-shm-usage
      disable-gpu
      window-size=390,844
    ]
  }
end
