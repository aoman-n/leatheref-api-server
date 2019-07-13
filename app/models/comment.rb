# == Schema Information
#
# Table name: comments
#
#  id                  :bigint           not null, primary key
#  user_id             :bigint
#  review_id           :bigint
#  in_reply_to_id      :bigint
#  comment             :text(65535)      not null
#  reply               :boolean          default(FALSE)
#  in_reply_to_user_id :bigint
#  like_count          :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :review
  belongs_to :thread, foreign_key: 'in_reply_to_id', class_name: 'Comment', optional: true
  belongs_to :in_reply_to_user, foreign_key: 'in_reply_to_user_id', class_name: 'User', optional: true
  has_many :replies, foreign_key: 'in_reply_to_id', class_name: 'Comment', dependent: :destroy
  has_many :likes, dependent: :destroy

  before_save :set_reply_to_user_id
  after_save :increment_count
  before_destroy :decrement_count

  validates :comment, presence: true, length: { maximum: 100 }

  scope :without_replies, -> {}

  def reply?
    !in_reply_to_id.nil? || attributes['reply']
  end

  def liked?(user)
    comment.likes.exists?(user_id: user.id)
  end

  private

  def set_reply_to_user_id
    if reply?
      comment = Comment.find_by(id: in_reply_to_id)
      self[:in_reply_to_user_id] = comment.user.id
    end
  end

  def increment_count
    review.update_column(:comment_count, review.comment_count + 1)
  end

  def decrement_count
    review.update_column(:comment_count, review.comment_count - 1)
  end
end
