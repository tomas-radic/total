class MatchPolicy < ApplicationPolicy

  def edit?
    update?
  end


  def update?
    user && record.assignments.find { |a| a.player_id == user.id }
  end


  def destroy?
    user && record.assignments.where(side: 1).find { |a| a.player_id == user.id }
  end


  def accept?
    user && record.assignments.where(side: 2).find { |a| a.player_id == user.id }
  end


  def reject?
    accept?
  end

end
