class PlayersController < ApplicationController

  # Temporary action, turn off later.
  def index
    @players = Player.where(anonymized_at: nil, access_denied_since: nil).order(created_at: :desc)
  end


  def show
    @player = Player.find params[:id]

    if selected_season.present?
      @all_matches = selected_season.matches.published.reviewed.sorted
                                    .joins(:assignments)
                                    .where(assignments: { player_id: @player.id })
                                    .includes(assignments: :player)
      @won_matches = @player.won_matches(selected_season)
    end
  end

end
