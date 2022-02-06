class Manager::EnrollmentsController < Manager::BaseController

  def toggle
    player = Player.find params[:player_id]
    @enrollment = @managed_season.enrollments.find_by(player_id: player.id)

    if @enrollment.present?
      @enrollment.update(canceled_at: @enrollment.canceled_at.present? ? nil : Time.now)
    else
      Enrollment.create(
        player: player,
        season: @managed_season,
        canceled_at: nil)
    end

    redirect_back fallback_location: manager_pages_dashboard_path
  end

end
