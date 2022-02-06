class Manager::PagesController < Manager::BaseController

  def dashboard
    @previous_season = Season.sorted.ended.first
    @players = Player.all.order(:name).includes(:enrollments)
  end

end
