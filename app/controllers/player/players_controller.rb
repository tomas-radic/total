class Player::PlayersController < Player::BaseController

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
