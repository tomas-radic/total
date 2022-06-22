class MatchesController < ApplicationController

  def index
    if selected_season.present?
      @matches = selected_season.matches.published.ranking_counted
                                .where(rejected_at: nil)
                                .order("finished_at desc nulls first")
                                .order("play_date asc nulls last, play_time asc nulls last, updated_at desc")
                                .includes(:place, :reactions, :comments, :reacted_players, :predictions, :players, assignments: :player)

      if player_signed_in?
        @pending_matches = @matches.joins(:assignments)
                      .where(assignments: { player_id: current_player.id }).distinct
                      .where(matches: {
                        rejected_at: nil,
                        finished_at: nil
                      })
                      .order("matches.play_date asc nulls last, matches.play_time asc nulls last, matches.updated_at desc")
                      .includes(:reactions, :comments, :predictions, :players, assignments: :player)
      end
    end
  end


  def show
    @match = Match.published.find params[:id]

    if current_player.present?
      @comment = @match.comments.new
      @player_prediction = @match.predictions.find_by(player: current_player)
    end
  end

end
