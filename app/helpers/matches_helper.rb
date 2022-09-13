module MatchesHelper

  def match_color_base(match)
    if match.reviewed?
      "base-green"
    elsif !match.rejected? && !match.canceled?
      "base-yellow"
    end
  end


  def match_player_link(match, side:, break_whitespace: false, options: {})
    match.assignments.select { |a| a.side == side }.map do |a|
      name = break_whitespace ? a.player.name.gsub(/\s+/, "<br>").html_safe : a.player.name
      link_to name, player_path(a.player), options
    end.join(", ").html_safe
  end


  def match_winner_link(match, break_whitespace: false, options: {})
    return nil unless match.finished?

    match.assignments.select { |a| a.side == match.winner_side }.map do |a|
      name = break_whitespace ? a.player.name.gsub(/\s+/, "<br>").html_safe : a.player.name
      link_to name, player_path(a.player), options
    end.join(", ").html_safe
  end


  def match_looser_link(match, break_whitespace: false, options: {})
    return nil unless match.finished?

    match.assignments.select { |a| a.side != match.winner_side }.map do |a|
      name = break_whitespace ? a.player.name.gsub(/\s+/, "<br>").html_safe : a.player.name
      link_to name, player_path(a.player), options
    end.join(", ").html_safe
  end

end
