class Player::ArticlesController < Player::BaseController

  def toggle_reaction
    @article = Article.published.find(params[:id])
    reaction = Reaction.find_by(reactionable: @article, player: current_player)

    if reaction.present?
      reaction.destroy!
    else
      Reaction.create!(reactionable: @article, player: current_player)
    end

    @article.reload

    render turbo_stream: [
      turbo_stream.replace("article_#{@article.id}_reactions",
                           partial: "shared/reactions_buttons",
                           locals: {
                             reactionable: @article,
                             toggle_reaction_path: toggle_reaction_player_article_path(@article),
                             object_path: article_path(@article)
                           })
    ]
  end

end
