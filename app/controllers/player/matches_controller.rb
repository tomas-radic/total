class Player::MatchesController < Player::BaseController

  before_action :load_and_authorize_record, except: [:create]
  after_action :verify_authorized, except: [:create]


  def create
    @requested_player = Player.find params[:player_id]

    now = Time.now
    match = selected_season.matches.create(
      requested_at: now,
      published_at: now,
      ranking_counted: true,
      assignments: [
        Assignment.new(player: current_player, side: 1),
        Assignment.new(player: @requested_player, side: 2)
      ])

    respond_to do |format|
      format.html do
        if match.persisted?
          flash[:notice] = "Výzva bola vytvorená. Kontaktuj vyzvaného súpera a dohodni si čas a miesto zápasu. Nezabudni, že dohodnutý čas a miesto môžeš zverejniť na tomto webe."
        else
          flash[:alert] = "#{match.errors.messages.values.flatten.join(' ')}"
        end

        redirect_to player_path(@requested_player)
      end
    end
  end


  def edit
    @match = Match.published.find params[:id]
    authorize @match
  end


  def update
    @match = Match.published.find params[:id]
    authorize @match

    respond_to do |format|
      if @match.update(whitelisted_params)
        format.html do
          flash[:notice] = "Údaje o zápase boli upravené."
          redirect_to match_path(@match)
        end

        format.turbo_stream
      else
        format.html do
          render :edit
        end

        format.turbo_stream do
          render :edit, status: :unprocessable_entity
        end
      end
    end
  end


  def destroy
    @match.destroy
    redirect_to root_path
  end


  def accept
    @match.update(accepted_at: Time.now)
    redirect_to match_path(@match)
  end


  def reject
    @match.update(rejected_at: Time.now)
    redirect_to match_path(@match)
  end


  private

  def whitelisted_params
    params.require(:match).permit(:play_date, :play_time, :notes, :place_id)
  end


  def load_and_authorize_record
    @match = Match.published.find params[:id]
    authorize @match
  end

end
