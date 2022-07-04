class Manager::BaseController < ApplicationController

  layout "manager"

  before_action :authenticate_manager!
  before_action :set_managed_season


  def authenticate_manager!
    super

    if current_manager.access_denied_since.present?
      sign_out current_manager
      redirect_to new_manager_session_path
    end
  end


  def set_managed_season
    @managed_season = Season.sorted.where(ended_at: nil).first
    @managed_season ||= Season.sorted.first
  end


  def ensure_managed_season
    if @managed_season.blank?
      redirect_to manager_pages_dashboard_path and return
    end
  end


  def pundit_user
    current_manager
  end

end
