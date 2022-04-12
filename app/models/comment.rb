class Comment < ApplicationRecord

  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :player
  belongs_to :motive, class_name: "Comment", optional: true
  has_many :comments, foreign_key: :motive_id


  validates :content, presence: true
  validate :same_commentable, if: Proc.new { |c| c.motive_id.present? }


  acts_as_list scope: :commentable


  private

  def same_commentable
    motive = Comment.find(motive_id)

    if (commentable_id != motive.commentable.id) || (commentable_type != motive.commentable_type)
      errors.add(:commentable, "sa nezhoduje")
    end
  end

end
