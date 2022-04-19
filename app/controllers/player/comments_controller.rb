class Player::CommentsController < Player::BaseController

  after_action :verify_authorized, except: [:delete]


  def create
    @match = Match.published.find_by!(id: params[:match_id])
    @comment = @match.comments.new(whitelisted_params)
    @comment.commentable = @match
    @comment.player = current_player
    authorize @comment

    if @comment.save
      redirect_to match_path(@match)
    else
      render "matches/show", status: :unprocessable_entity
    end
  end


  def edit
    @match = Match.published.find_by!(id: params[:match_id])
    @comment = current_player.comments.find(params[:id])
    authorize @comment
  end


  def update
    @match = Match.published.find_by!(id: params[:match_id])
    @comment = current_player.comments.find(params[:id])
    authorize @comment

    if @comment.update(whitelisted_params)
      redirect_to match_path(@comment.commentable)
    else
      render "matches/show", status: :unprocessable_entity
    end
  end


  def delete
    @match = Match.published.find_by!(id: params[:match_id])
    @comment = current_player.comments.find(params[:id])
    @comment.update!(deleted_at: Time.now)


    redirect_to match_path(@comment.commentable)
  end


  private

  def whitelisted_params
    params.require(:comment).permit(:content, :motive_id)
  end

end
