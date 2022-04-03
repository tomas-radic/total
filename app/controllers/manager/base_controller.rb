class Manager::BaseController < ApplicationController

  layout "manager"

  before_action :authenticate_manager!
  before_action :set_managed_season


  def authenticate_manager!
    # TODO: check for access_denied_since attribute here and sign out manager if needed.
    super
  end


  def set_managed_season
    @managed_season = Season.sorted.where(ended_at: nil).first
    @managed_season ||= Season.sorted.first
  end


  def pundit_user
    current_manager
  end

end
