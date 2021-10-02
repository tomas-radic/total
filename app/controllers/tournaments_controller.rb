class TournamentsController < ApplicationController

  def index
    @tournaments = Tournament.published.sorted
  end


  def show
    @tournament = Tournament.published.find(params[:id])
  end

end
