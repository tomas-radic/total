class CommentPolicy < ApplicationPolicy

  def create?
    can_comment? && commentable?
  end


  def edit?
    update?
  end


  def update?
    is_author? && can_comment? && commentable?
  end


  def delete?
    is_author?
  end


  private

  def is_author?
    record.player_id == user.id
  end


  def can_comment?
    user.comments_disabled_since.blank?
  end


  def commentable?
    record.commentable.respond_to?(:comments_disabled_since) && record.commentable.comments_disabled_since.blank?
  end

end
