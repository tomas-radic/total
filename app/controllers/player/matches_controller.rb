class Player::MatchesController < Player::BaseController

  before_action :load_and_authorize_record, except: [:create]
  after_action :verify_authorized, except: [:create]


  def create
    @requested_player = Player.find params[:player_id]

    now = Time.now
    @match = selected_season.matches.create(
      requested_at: now,
      published_at: now,
      ranking_counted: true,
      assignments: [
        Assignment.new(player: current_player, side: 1),
        Assignment.new(player: @requested_player, side: 2)
      ]
    )

    redirect_to player_path(@requested_player)
  end


  def edit

  end


  def update
    if @match.update(whitelisted_params)
      # flash[:notice] = "Údaje boli upravené."

      @match.assignments.each do |assignment|
        Turbo::StreamsChannel.broadcast_update_to(
          "match_#{@match.id}_for_player_#{assignment.player.id}",
          partial: "matches/match", locals: { match: @match, current_player: assignment.player },
          target: "match_#{@match.id}"
        )
      end

      redirect_to match_path(@match)
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    @match.destroy
    # flash[:notice] = "Výzva bola zmazaná."
    redirect_to root_path
  end


  def accept
    if @match.update(accepted_at: Time.now)
      # flash[:notice] = "Výzva akceptovaná! Zavolaj súperovi a zverejnite miesto a čas zápasu."

      @match.assignments.each do |assignment|
        Turbo::StreamsChannel.broadcast_update_to(
          "match_#{@match.id}_for_player_#{assignment.player.id}",
          partial: "matches/match", locals: { match: @match, current_player: assignment.player },
          target: "match_#{@match.id}"
        )
      end
    else
      # flash[:alert] = "#{@match.errors.messages.values.flatten.join(' ')}"
    end

    redirect_to match_path(@match)
  end


  def reject
    if @match.update(rejected_at: Time.now)
      # flash[:alert] = "Výzva bola odmietnutá."

      @match.assignments.each do |assignment|
        Turbo::StreamsChannel.broadcast_update_to(
          "match_#{@match.id}_for_player_#{assignment.player.id}",
          partial: "matches/match", locals: { match: @match, current_player: assignment.player },
          target: "match_#{@match.id}"
        )
      end
    end

    redirect_to match_path(@match)
  end


  def finish_init

  end


  def finish
    @match.finish params.slice(
      "score",
      "retired_player_id",
      "play_date",
      "place_id",
      "notes"
    ).merge("score_side" => @match.assignments.find { |a| a.player_id == current_player.id }.side)

    if @match.reload.finished_at.present?
      # flash[:notice] = "Zápas bol ukončený."

      @match.assignments.each do |assignment|
        Turbo::StreamsChannel.broadcast_update_to(
          "match_#{@match.id}_for_player_#{assignment.player.id}",
          partial: "matches/match", locals: { match: @match, current_player: assignment.player },
          target: "match_#{@match.id}"
        )
      end
    else
      # flash[:alert] = "#{@match.errors.messages.values.flatten.join(' ')}"
    end

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
