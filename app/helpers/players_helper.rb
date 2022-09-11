module PlayersHelper

  def match_request_possible(player, requested_player:, season:)

    false # TODO: requesting matches temporarily disabled

    # return false if season.blank? || season.ended_at
    # return false if requested_player.access_denied_since.present?
    # return false if requested_player.anonymized_at.present?
    # return false if requested_player.cant_play_since.present?
    # return false if player == requested_player
    # return false if player.enrollments.active.find_by(season: season).blank?
    # return false if requested_player.enrollments.active.find_by(season: season).blank?
    # return false if player.opponents(season: season, pending: true, ranking_counted: true).include?(requested_player)
    #
    # true
  end
end
