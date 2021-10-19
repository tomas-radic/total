class MatchesController < ApplicationController

  def index
    @matches = Match.published.ranking_counted
                    .where(rejected_at: nil)
                    .order("finished_at desc nulls first")
                    .order("play_date asc nulls last, play_time asc nulls last")
                    .includes(assignments: :player)

    if player_signed_in?
      @pending_matches = current_player.matches
                                       .where.not(requested_at: nil)
                                       .where(finished_at: nil, rejected_at: nil)
                                       .order(:requested_at)
                                       .includes(assignments: :player)
    end
  end


  def show
    @match = Match.published.find params[:id]
  end

end
