class ApplicationController < ActionController::Base

  include Pundit

  before_action :sign_out_anonymized!, if: :player_signed_in?


  private

  helper_method :selected_season

  def selected_season
    @season ||= Season.sorted.first
  end


  def pundit_user
    current_player
  end


  def sign_out_anonymized!
    if current_player.anonymized_at.present?
      sign_out current_player
      redirect_to root_path
    end
  end

end
