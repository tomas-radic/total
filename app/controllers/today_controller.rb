class TodayController < ApplicationController

  def index
    if selected_season.present?
      season_matches = selected_season.matches.published

      @requested_matches = season_matches.ranking_counted.requested
                                         .where(finished_at: nil)
                                         .order(requested_at: :desc)
                                         .includes(:reactions, :comments, :reacted_players, assignments: :player)

      @rejected_matches = season_matches.ranking_counted.rejected
                                        .where("rejected_at >= ?", 48.hours.ago)
                                        .includes(:reactions, :comments, :reacted_players, assignments: :player)

      begins_in_days = Date.today + 12.days
      ended_before_days = Date.today - 2.days
      @upcoming_tournaments = selected_season.tournaments.published
                                             .where("(begin_date < ? or end_date < ?) and (end_date >= ?)",
                                                    begins_in_days, begins_in_days, ended_before_days)
      @actual_articles = selected_season.articles.published
                                        .where("(promote_until is not null and promote_until >= ?) or (created_at > ?)",
                                               Date.today, 4.days.ago)

      @recent_matches = season_matches.reviewed.ranking_counted
                                      .where("finished_at >= ?", 7.days.ago)
                                      .order(finished_at: :desc)
                                      .includes(:reactions, :comments, :reacted_players, assignments: :player)

      @planned_matches = season_matches.accepted.ranking_counted
                                       .where(finished_at: nil)
                                       .order(:play_date, :play_time)
                                       .includes(:reactions, :comments, :reacted_players, :place, assignments: :player)

      @top_rankings = Rankings.calculate(selected_season, single_matches: true)
                              .slice(0, selected_season.play_off_size + 2)

      @players_open_to_play = selected_season.players
                                             .where.not(open_to_play_since: nil)
                                             .order(open_to_play_since: :desc)
    end
  end

end
