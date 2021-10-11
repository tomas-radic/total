class RankingsController < ApplicationController

  def index
    @rankings = Rankings.calculate(selected_season, single_matches: true)
  end

end
