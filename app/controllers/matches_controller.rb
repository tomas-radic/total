class MatchesController < ApplicationController

  def index
    @matches = selected_season.matches.published.ranking_counted
                              .where(rejected_at: nil)
                              .order("finished_at desc nulls first")
                              .order("play_date asc nulls last, play_time asc nulls last")
                              .includes(assignments: :player)

    if player_signed_in?
      @pending_matches = @matches.select do |match|
        match.assignments.find { |a| a.player_id == current_player.id } &&
          match.rejected_at.nil? &&
          match.finished_at.nil?
      end.sort_by { |m| -m.requested_at.to_i }
    end
  end


  def show
    @match = selected_season.matches.published.find params[:id]
  end

end
