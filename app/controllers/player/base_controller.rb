class Player::BaseController < ApplicationController

  before_action :authenticate_player!
  before_action :verify_player!


  private

  def verify_player!
    if current_player.access_denied_since.present? || current_player.anonymized_at.present?
      sign_out current_player
      redirect_to root_path
    end
  end

end
