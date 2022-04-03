class Manager::PagesController < Manager::BaseController

  def dashboard
    @players = Player.all.order(:name).includes(:enrollments)
  end

end
