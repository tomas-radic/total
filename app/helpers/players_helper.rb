module PlayersHelper

  def match_request_possible(player, requested_player:, season:)
    return false if season.ended_at
    return false if player.enrollments.active.find_by(season: season).blank?
    return false if requested_player.enrollments.active.find_by(season: season).blank?

    true
  end
end
