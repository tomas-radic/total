class CommentPolicy < ApplicationPolicy

  def create?
    return false if user.comments_disabled_since.present? || record.commentable.comments_disabled_since.present?

    true
  end


  def edit?
    update?
  end


  def update?
    return false if user.comments_disabled_since.present? || record.commentable.comments_disabled_since.present?

    true
  end

end
