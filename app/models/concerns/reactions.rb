module Reactions

  extend ActiveSupport::Concern

  included do
    has_many :reactions, as: :reactionable, dependent: :destroy
    has_many :reacted_players, through: :reactions, source: :player
    has_many :comments, as: :commentable
  end


  def reacted_player_names(max_count: nil)
    result = reacted_players.map { |p| p.name }
    result = result[0...max_count] if max_count.present?
    result = result.join(", ")
    result += " ..." if max_count.present? && (reactions_count > max_count)
    result
  end
end
