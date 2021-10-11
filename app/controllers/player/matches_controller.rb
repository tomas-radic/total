class Player::MatchesController < Player::BaseController

  def create
    @requested_player = Player.find params[:player_id]

    enrollments = selected_season.enrollments
    player_enrollment = enrollments.find { |e| e.canceled_at.nil? && e.player_id == current_player.id }
    requested_player_enrollment = enrollments.find { |e| e.canceled_at.nil? && e.player_id == @requested_player.id }

    if player_enrollment.nil?
      flash[:alert] = "Nie si prihlásený do sezóny. Kontaktuj manažéra súťaže."
      redirect_to player_path(@requested_player) and return
    elsif requested_player_enrollment.nil?
      flash[:alert] = "Tento hráč nie je prihlásený do sezóny. Požiadaj ho najskôr nech sa prihlási u manažéra súťaže."
      redirect_to player_path(@requested_player) and return
    end

    matches = selected_season.matches.single.where(finished_at: nil, rejected_at: nil)
                             .joins(:assignments)
                             .where(
                               "assignments.player_id in (?)",
                               [current_player.id, @requested_player.id])
                             .includes(:assignments)

    existing_match = matches.find do |m|
      m.assignments.find { |a| a.player_id == current_player.id } &&
        m.assignments.find { |a| a.player_id == @requested_player.id }
    end

    if existing_match
      flash[:alert] = "Výzvu nie je možné  vytvoriť, pretože takáto výzva už existuje. Pokiaľ nie je zobrazená na stránke medzi výzvami, kontaktuj manažéra súťaže."
    else
      now = Time.now
      match = selected_season.matches.create(
        requested_at: now,
        published_at: now,
        assignments: [
          Assignment.new(player: current_player, side: 1),
          Assignment.new(player: @requested_player, side: 2)
        ])

      if match.persisted?
        flash[:notice] = "Výzva bola vytvorená. Kontaktuj vyzvaného súpera a dohodni si čas a miesto zápasu. Nezabudni, že dohodnutý čas a miesto môžeš zverejniť na tomto webe."
      else
        flash[:alert] = "Výzvu nie je možné vytvoriť. Kontaktuj manažéra súťaže."
      end
    end

    redirect_to player_path(@requested_player)
  end

end
