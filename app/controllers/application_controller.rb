class ApplicationController < ActionController::Base

  include Pundit

  before_action :verify_player!, if: :player_signed_in?


  private

  helper_method :selected_season

  def selected_season
    @season ||= Season.sorted.first
  end


  def pundit_user
    current_player
  end


  def verify_player!
    if current_player.access_denied_since.present? || current_player.anonymized_at.present?
      sign_out current_player
      redirect_to root_path
    end
  end

end
