class MatchPolicy < ApplicationPolicy

  def edit?
    update?
  end


  def update?
    user && record.ranking_counted? &&
      record.assignments.find { |a| a.player_id == user.id }
  end


  def destroy?
    user && record.ranking_counted? &&
      record.assignments.where(side: 1).find { |a| a.player_id == user.id } && !record.closed?
  end


  def accept?
    user && record.ranking_counted? &&
      record.assignments.where(side: 2).find { |a| a.player_id == user.id } && !record.closed?
  end


  def reject?
    accept?
  end


  def close?
    update?
  end

end
