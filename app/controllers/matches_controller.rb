class MatchesController < ApplicationController

  def index
    @matches = Match.published.ranking_counted
                    .where(rejected_at: nil)
                    .order("finished_at desc nulls first")
                    .order("play_date asc nulls last, play_time asc nulls last")
                    .includes(assignments: :player)
  end

end
