class MatchPolicy < ApplicationPolicy

  def update?
    record.players.include? player
  end

end
