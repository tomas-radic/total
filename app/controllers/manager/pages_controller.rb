class Manager::PagesController < Manager::BaseController

  def dashboard
    @players = Player.all.order(created_at: :desc).includes(:enrollments)
  end

end
