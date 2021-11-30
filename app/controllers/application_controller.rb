class ApplicationController < ActionController::Base

  include Pundit


  private

  helper_method :selected_season

  def selected_season
    @season ||= Season.sorted.first
  end


  def pundit_user
    current_player
  end

end
