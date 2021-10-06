class TodayController < ApplicationController

  def index
    season_matches = selected_season.matches.published
    last_days = 7.days.ago

    @requested_matches = season_matches.ranking_counted.requested
                                       .where(finished_at: nil)
                                       .where("requested_at >= ?", last_days)
                                       .order(requested_at: :desc)
                                       .includes(assignments: :player)

    @rejected_matches = season_matches.ranking_counted.rejected
                                      .where("rejected_at >= ?", last_days)

    @recent_matches = season_matches.reviewed.ranking_counted
                                    .where("finished_at >= ?", last_days)
                                    .order(finished_at: :desc)
                                    .includes(assignments: :player)

    @planned_matches = season_matches.accepted.ranking_counted
                                     .where(finished_at: nil)
                                     .order(:play_date, :play_time)
                                     .includes(assignments: :player)

    @top_rankings = Rankings.calculate(selected_season, single_matches: true)
                            .slice(0, selected_season.play_off_size + 2)
  end

end
