class Player::Matches::CommentsController < Player::CommentsController

  before_action :load_match


  def create
    @comment = @match.comments.new(whitelisted_params)
    super
  end


  private

  def load_match
    @match = Match.published
                  .where(comments_disabled_since: nil)
                  .find(params[:match_id])
  end


  # def record_invalid_template
  #   "matches/show"
  # end

end
