class Player::PlayersController < Player::BaseController

  def toggle_open_to_play
    open_to_play_since = if current_player.open_to_play_since.blank?
                           Time.now
                         end

    if current_player.update(open_to_play_since: open_to_play_since)
      @players_open_to_play = Player.where.not(open_to_play_since: nil)
                                    .order(open_to_play_since: :desc)

      Turbo::StreamsChannel.broadcast_update_to "players_open_to_play",
                                                target: "players_open_to_play",
                                                partial: "shared/players_open_to_play",
                                                locals: { players: @players_open_to_play }

      Turbo::StreamsChannel.broadcast_update_to "players_open_to_play",
                                                target: "players_open_to_play_top",
                                                partial: "shared/players_open_to_play",
                                                locals: { players: @players_open_to_play }
    end

    render partial: "shared/navbar"
  end


  def anonymize
    if params[:confirmation_email] == current_player.email
      current_player.anonymize!
      sign_out current_player
      redirect_to root_path
    else
      redirect_to edit_player_registration_path
    end
  end
end
