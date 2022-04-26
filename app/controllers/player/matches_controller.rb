class Player::MatchesController < Player::BaseController

  before_action :load_and_authorize_record, except: [:create, :toggle_reaction]
  after_action :verify_authorized, except: [:toggle_reaction]


  def create
    @requested_player = Player.where(anonymized_at: nil).find params[:player_id]

    if selected_season.blank? || selected_season.ended_at
      flash[:notice] = "Sezóna je ukončená."
      redirect_to player_path(@requested_player) and return
    end

    now = Time.now
    @match = selected_season.matches.new(
      requested_at: now,
      published_at: now,
      ranking_counted: true,
      assignments: [
        Assignment.new(player: current_player, side: 1),
        Assignment.new(player: @requested_player, side: 2)
      ]
    )

    authorize @match
    @match.save
    current_player.update(cant_play_since: nil)
    redirect_to player_path(@requested_player)
  end


  def edit

  end


  def update
    if @match.update(whitelisted_params)
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
    redirect_to root_path
  end


  def accept
    ActiveRecord::Base.transaction do
      @match.update(accepted_at: Time.now)
      @match.players.update_all(open_to_play_since: nil)

      @players_open_to_play = Player.where.not(open_to_play_since: nil)
                                    .order(open_to_play_since: :desc)

      Turbo::StreamsChannel.broadcast_update_to "players_open_to_play",
                                                target: "players_open_to_play",
                                                partial: "shared/players_open_to_play",
                                                locals: { players: @players_open_to_play }

      Turbo::StreamsChannel.broadcast_update_to "players_open_to_play",
                                                target: "players_open_to_play_top",
                                                partial: "shared/players_open_to_play",
                                                locals: { players: @players_open_to_play }

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


  def reject
    @match.update(rejected_at: Time.now)
    @match.assignments.each do |assignment|
      Turbo::StreamsChannel.broadcast_update_to(
        "match_#{@match.id}_for_player_#{assignment.player.id}",
        partial: "matches/match", locals: { match: @match, current_player: assignment.player },
        target: "match_#{@match.id}"
      )
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

    if @match.finished_at.present? && @match.errors.none?
      @match.assignments.each do |assignment|
        Turbo::StreamsChannel.broadcast_update_to(
          "match_#{@match.id}_for_player_#{assignment.player.id}",
          partial: "matches/match", locals: { match: @match, current_player: assignment.player },
          target: "match_#{@match.id}"
        )
      end

      redirect_to match_path(@match)
    else
      render :finish_init, status: :unprocessable_entity
    end
  end


  def toggle_reaction
    @match = Match.published.find(params[:id])
    reaction = Reaction.find_by(reactionable: @match, player: current_player)

    if reaction.present?
      reaction.destroy!
    else
      Reaction.create!(reactionable: @match, player: current_player)
    end

    @match.reload

    Turbo::StreamsChannel.broadcast_replace_to "matches",
                                               target: "match_#{@match.id}_reactions",
                                               partial: "shared/reactions",
                                               locals: { reactionable: @match, current_player: current_player }
    Turbo::StreamsChannel.broadcast_replace_to "matches",
                                               target: "tiny_match_#{@match.id}_tiny_reactions",
                                               partial: "shared/reactions_tiny",
                                               locals: { reactionable: @match, current_player: current_player }

    # render turbo_stream: [
    #   turbo_stream.replace("match_#{@match.id}_reactions",
    #                        partial: "shared/reactions",
    #                        locals: { reactionable: @match }),
    #   turbo_stream.replace("tiny_match_#{@match.id}_tiny_reactions",
    #                        partial: "shared/reactions_tiny",
    #                        locals: { reactionable: @match })
    # ]
  end


  private

  def whitelisted_params
    params.require(:match).permit(:play_date, :play_time, :notes, :place_id)
  end


  def load_and_authorize_record
    @match = Match.published.find_by id: params[:id]
    redirect_to(root_path) and return if @match.blank?
    authorize @match
  end

end
