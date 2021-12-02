class TournamentsController < ApplicationController

  def index
    if selected_season.present?
      @tournaments = Tournament.published.sorted
    end
  end


  def show
    @tournament = Tournament.published.find(params[:id])
  end

end
