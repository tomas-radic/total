class MatchPolicy < ApplicationPolicy

  def edit?
    update?
  end

  def update?
    user && record.players.include?(user)
  end

end
