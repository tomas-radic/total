module Player::CommentsHelper

  def edit_comment_path(comment)
    case comment.commentable.class.to_s
    when "Match"
      edit_player_match_comment_path(comment.commentable, comment)
    when "Article"
      edit_player_article_comment_path(comment.commentable, comment)
    when "Tournament"
      edit_player_tournament_comment_path(comment.commentable, comment)
    end
  end


  def delete_comment_path(comment)
    case comment.commentable.class.to_s
    when "Match"
      delete_player_match_comment_path(comment.commentable, comment)
    when "Article"
      delete_player_article_comment_path(comment.commentable, comment)
    when "Tournament"
      delete_player_tournament_comment_path(comment.commentable, comment)
    end
  end
end
