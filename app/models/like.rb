class Like < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :comment_id, presence: true
  validates :user_id, presence: true, uniqueness: {
    scope: :comment_id, message: "コメントに対して一つのライクしか出来ません。",
  }

  def is_liked?
  end
end
