class TodayController < ApplicationController

  def index
    season_matches = selected_season.matches.published
    @recent_matches = season_matches.finished.ranking_counted
                                    .where("finished_at > ?", 7.day.ago)
                                    .order(finished_at: :desc)
                                    .includes(assignments: :player)

    @planned_matches = season_matches.where(finished_at: nil)
                                     .order(:play_date, :play_time)
                                     .includes(assignments: :player)

    @top_rankings = Rankings.calculate(selected_season, single_matches: true)
                            .slice(0, selected_season.play_off_size + 2)
  end

end
