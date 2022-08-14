class Player::Articles::CommentsController < Player::CommentsController

  before_action :load_article

  def create
    @comment = @article.comments.new(whitelisted_params)
    super
  end


  private

  def load_article
    @article = Article.published
                      .where(comments_disabled_since: nil)
                      .find(params[:article_id])
  end

end
