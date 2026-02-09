class LiffController < ApplicationController
  skip_before_action :authenticate_user!, raise: false

  def show
    @liff_id = ENV.fetch("LIFF_ID")
  end
end
