# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  comment_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :comment_id, presence: true
  validates :user_id, presence: true, uniqueness: {
    scope: :comment_id, message: "コメントに対して一つのライクしか出来ません。",
  }

  after_save :increment_count
  after_destroy :decrement_count

  def increment_count
    comment = self.comment
    comment.update_column(:like_count, comment.like_count + 1)
  end

  def decrement_count
    comment = self.comment
    comment.update_column(:like_count, comment.like_count - 1)
  end
end
