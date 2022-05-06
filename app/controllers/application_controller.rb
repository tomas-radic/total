class ApplicationController < ActionController::Base

  include Pundit

  rescue_from(ActiveRecord::RecordNotFound) { redirect_to not_found_path }
  rescue_from(Pundit::NotAuthorizedError) { redirect_to root_path }


  private

  helper_method :selected_season
  helper_method :latest_open_season

  def selected_season
    @selected_season ||= Season.sorted.first
  end


  def latest_open_season
    @latest_open_season ||= Season.where(ended_at: nil).order(:position).last
  end


  def pundit_user
    current_player
  end

end
