class Player::MatchesController < Player::BaseController

  after_action :verify_authorized, except: [:create]


  def create
    @requested_player = Player.find params[:player_id]

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
      flash[:alert] = "#{match.errors.messages.values.flatten.join(' ')}"
    end

    redirect_to player_path(@requested_player)
  end


  def edit
    @match = Match.published.find params[:id]
    authorize @match
  end


  def update
    @match = Match.published.find params[:id]
    authorize @match

    if @match.update(whitelisted_params)
      flash[:notice] = "Údaje o zápase boli upravené."
      redirect_to match_path(@match)
    else
      render :edit
    end
  end


  private

  def whitelisted_params
    params.require(:match).permit(:play_date, :play_time, :notes, :place_id)
  end

end
