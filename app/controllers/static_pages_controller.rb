class StaticPagesController < ApplicationController
  def top
    @hide_footer = true
  end
end
