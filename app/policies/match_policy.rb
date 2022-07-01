class MatchPolicy < ApplicationPolicy

  def create?
    return false unless user.present?
    return false if season_ended?(record)

    player_enrolled?(user, record)
  end


  def edit?
    update?
  end


  def update?
    return false unless user.present?
    return false if season_ended?(record)
    return false unless record.ranking_counted?
    return false unless record.accepted_at.present?

    record.assignments.find { |a| a.player_id == user.id }
  end


  def destroy?
    return false unless user.present?
    return false if season_ended?(record)
    return false unless record.ranking_counted?
    return false if record.accepted? || record.rejected? || record.reviewed?

    record.assignments.where(side: 1)
          .find { |a| a.player_id == user.id }
  end


  def accept?
    return false unless user.present?
    return false if season_ended?(record)
    return false unless record.ranking_counted?
    return false if record.reviewed?
    return false if record.canceled?

    record.assignments.where(side: 2)
          .find { |a| a.player_id == user.id }
  end


  def reject?
    accept?
  end


  def finish_init?
    finish?
  end


  def finish?
    if user.is_a?(Player)
      if record.competitable.is_a?(Season)
        return false if record.competitable.ended_at.present?
        return false unless update?
        return false if record.canceled?
        return false if record.rejected?
        return false unless record.accepted?

        record.finished_at.blank? ||
          (record.finished_at >= Rails.configuration.minutes_refinish_match.minutes.ago)
      else
        return false
      end


    elsif user.is_a?(Manager)
      # TODO
      false
    else
      false
    end
    # update? && !record.rejected? && !record.reviewed?
  end


  def cancel?
    if record.competitable.is_a?(Season)
      return false unless record.assignments.find { |a| a.player_id == user.id }
      return false if record.canceled?
      return false if record.finished?
      return false if record.rejected?
      return false if record.requested?
      true
    else
      false
    end
  end


  def switch_prediction?
    return false unless user.present?
    return false unless record.published?
    return false if record.reviewed?
    return false if record.canceled?
    return false if record.predictions_disabled_since.present?

    true
  end


  private

  def player_enrolled?(player, match)
    player.enrollments.active.where(season_id: match.season&.id).exists?
  end


  def season_ended?(record)
    season = record.season
    season&.ended_at.present?
  end

end
