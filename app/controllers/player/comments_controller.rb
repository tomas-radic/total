class Player::CommentsController < Player::BaseController

  def new
    @comment = Match.find(params[:comment][:match_id]).comments.new
  end


  def create
    @match = Match.find(params[:match_id])
    @comment = @match.comments.new(whitelisted_params)
    @comment.commentable = @match
    @comment.player = current_player

    if @comment.save
      redirect_to match_path(@match)
    else
      render "matches/show", status: :unprocessable_entity
    end
  end


  def edit
    @comment = current_player.comments.find(params[:id])
  end


  def update
    @comment = current_player.comments.find(params[:id])

    if @comment.update(whitelisted_params)
      redirect_to match_path(@comment.commentable)
    else
      render "matches/show", status: :unprocessable_entity
    end
  end


  def delete
    @comment = current_player.comments.find(params[:id])
    @comment.update!(deleted_at: Time.now)

    redirect_to match_path(@comment.commentable)
  end


  private

  def whitelisted_params
    params.require(:comment).permit(:content)
  end

end
