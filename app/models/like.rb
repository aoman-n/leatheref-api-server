class Like < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :comment_id, presence: true
  validates :user_id, presence: true, uniqueness: {
    scope: :comment_id, message: "コメントに対して一つのライクしか出来ません。",
  }

  after_save :increment_count
  after_destroy :decrement_count

  private

  # commentクラスに問い合わせるような形にする
  def increment_count
    comment = self.comment
    comment.update_column(:like_count, comment.like_count + 1)
  end

  def decrement_count
    comment = self.comment
    comment.update_column(:like_count, comment.like_count - 1)
  end
end
