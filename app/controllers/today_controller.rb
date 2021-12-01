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
                                      .includes(assignments: :player)

    begins_in_days = Date.today + 12.days
    ended_before_days = Date.today - 2.days
    @upcoming_tournaments = selected_season.tournaments.published
                                           .where("(begin_date < ? or end_date < ?) and (end_date >= ?)",
                                                  begins_in_days, begins_in_days, ended_before_days)

    @recent_matches = season_matches.reviewed.ranking_counted
                                    .where("finished_at >= ?", last_days)
                                    .order(finished_at: :desc)
                                    .includes(assignments: :player)

    @planned_matches = season_matches.accepted.ranking_counted
                                     .where(finished_at: nil)
                                     .order(:play_date, :play_time)
                                     .includes(:place, assignments: :player)

    @top_rankings = Rankings.calculate(selected_season, single_matches: true)
                            .slice(0, selected_season.play_off_size + 2)
  end

end
