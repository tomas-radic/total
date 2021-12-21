class PlayersController < ApplicationController

  def show
    @player = Player.find params[:id]

    if selected_season.present?
      @all_matches = selected_season.matches.reviewed.sorted
                                    .joins(:assignments)
                                    .where(assignments: { player_id: @player.id })
                                    .includes(assignments: :player)
      @won_matches = @player.won_matches(selected_season)
    end
  end

end
