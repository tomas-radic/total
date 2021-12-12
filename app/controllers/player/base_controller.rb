class Player::BaseController < ApplicationController

  before_action :authenticate_player!
  before_action :sign_out_anonymized!


  private

  def sign_out_anonymized!
    if current_player.anonymized_at.present?
      sign_out current_player
      redirect_to root_path
    end
  end

end
