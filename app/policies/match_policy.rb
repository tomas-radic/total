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
    update? && !record.rejected? && !record.reviewed?
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
