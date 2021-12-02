class RankingsController < ApplicationController

  def index
    if selected_season.present?
      @rankings = Rankings.calculate(selected_season, single_matches: true)
    end
  end

end
