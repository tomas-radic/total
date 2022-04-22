class TournamentsController < ApplicationController

  def index
    if selected_season.present?
      @tournaments = selected_season.tournaments.published.sorted
    end
  end


  def show
    @tournament = selected_season.tournaments.published.find(params[:id])
  end

end
