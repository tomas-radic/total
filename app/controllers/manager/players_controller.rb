class Manager::PlayersController < Manager::BaseController

  before_action :load_player, only: [:edit, :update, :deny_access, :grant_access]


  def edit
  end


  def update
  end


  def deny_access
    @player.update(access_denied_since: Time.now)
    redirect_back fallback_location: manager_pages_dashboard_path
  end


  def grant_access
    @player.update(access_denied_since: nil)
    redirect_back fallback_location: manager_pages_dashboard_path
  end


  private

  def load_player
    @player = Player.find params[:id]
  end

end
