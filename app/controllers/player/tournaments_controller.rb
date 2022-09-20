class Player::TournamentsController < Player::BaseController

  def toggle_reaction
    @tournament = Tournament.published.find(params[:id])
    reaction = Reaction.find_by(reactionable: @tournament, player: current_player)

    if reaction.present?
      reaction.destroy!
    else
      Reaction.create!(reactionable: @tournament, player: current_player)
    end

    @tournament.reload

    render turbo_stream: [
      turbo_stream.replace("tournament_#{@tournament.id}_reactions",
                           partial: "shared/reactions_buttons",
                           locals: {
                             reactionable: @tournament,
                             toggle_reaction_path: toggle_reaction_player_tournament_path(@tournament),
                             object_path: tournament_path(@tournament)
                           })
    ]
  end

end
