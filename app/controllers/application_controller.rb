class ApplicationController < ActionController::Base

  include Pundit

  rescue_from(ActiveRecord::RecordNotFound) { redirect_to not_found_path }
  rescue_from(Pundit::NotAuthorizedError) { redirect_to root_path }


  private

  helper_method :selected_season

  def selected_season
    @season ||= Season.sorted.first
  end


  def pundit_user
    current_player
  end

end
