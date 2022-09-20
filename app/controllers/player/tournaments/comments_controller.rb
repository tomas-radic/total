class Player::Tournaments::CommentsController < Player::CommentsController

  before_action :load_tournament

  def create
    @comment = @tournament.comments.new(whitelisted_params)
    super
  end


  private

  def load_tournament
    @tournament = Tournament.published
                            .where(comments_disabled_since: nil)
                            .find(params[:tournament_id])
  end

end
