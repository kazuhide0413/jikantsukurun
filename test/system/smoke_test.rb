require "application_system_test_case"

class SmokeTest < ApplicationSystemTestCase
  test "visiting root page" do
    visit root_path
    assert_text "時間作るん"
  end
end
