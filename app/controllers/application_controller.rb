class ApplicationController < ActionController::Base

  private


  helper_method :selected_season

  def selected_season
    @season ||= Season.sorted.first
  end

end
