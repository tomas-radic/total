class Rankings

  def self.calculate(season, single_matches: false, double_matches: false)
    self.new(season, single_matches: single_matches, double_matches: double_matches).calculate
  end


  def initialize(season, single_matches:, double_matches:)
    @season = season
    @single_matches = single_matches
    @double_matches = double_matches
  end


  def calculate
    result = Player.where(anonymized_at: nil).left_joins(:matches)
                   .where(enrollments: { season_id: @season.id })
                   .merge(Enrollment.active)
                   .includes(:enrollments, matches: :players).map do |player|

      matches = if @single_matches && @double_matches
                  player.matches
                elsif @single_matches && !@double_matches
                  player.matches.singles
                elsif !@single_matches && @double_matches
                  player.matches.doubles
                else
                  Match.none
                end

      matches = matches.published.reviewed.ranking_counted.includes(:assignments)
      points = 0
      nr_matches = matches.length
      nr_won_matches = 0

      matches.each do |match|
        player_assignment = match.assignments.find { |a| a.player_id == player.id }

        if match.winner_side == player_assignment.side
          nr_won_matches += 1
          points += points_to_add(match, :won)
        else
          points += points_to_add(match, :lost)
        end
      end

      {
        id: player.id,
        name: player.name,
        played: nr_matches,
        won: nr_won_matches,
        points: points,
        percentage: nr_matches > 0 ? (((nr_won_matches * 100.0) / nr_matches) * 100).round : 0,
        nr_matches: nr_matches,
        enrolled_at: player.enrollments.find { |e| e.season_id == @season.id }.created_at
      }
    end

    result.sort_by do |r|
      [-r[:points], -r[:percentage], -r[:nr_matches], r[:enrolled_at]]
    end
  end


  private


  def points_to_add(match, result)
    case result
    when :won
      if match.single?
        if match.played_3rd_set?
          @season.points_single_21
        else
          @season.points_single_20
        end
      elsif match.double?
        if match.played_3rd_set?
          @season.points_double_21
        else
          @season.points_double_20
        end
      end
    when :lost
      if match.single?
        if match.played_3rd_set?
          @season.points_single_12
        else
          @season.points_single_02
        end
      elsif match.double?
        if match.played_3rd_set?
          @season.points_double_12
        else
          @season.points_double_02
        end
      end
    else
      0
    end
  end

end
