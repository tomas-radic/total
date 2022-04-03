class Manager::PlayersController < Manager::BaseController

  before_action :load_player, only: [:edit, :update, :toggle_access]


  def edit
  end


  def update
  end


  def toggle_access
    if @player.access_denied_since.nil?
      @player.update(access_denied_since: Time.now)
    else
      @player.update(access_denied_since: nil)
    end

    redirect_back fallback_location: manager_pages_dashboard_path
  end


  private

  def load_player
    @player = Player.find params[:id]
  end

end
