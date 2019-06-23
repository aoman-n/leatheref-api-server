class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :review
  belongs_to :thread, foreign_key: 'in_reply_to_id', class_name: 'Comment', optional: true
  belongs_to :in_reply_to_user, foreign_key: 'in_reply_to_user_id', class_name: 'User', optional: true
  has_many :replies, foreign_key: 'in_reply_to_id', class_name: 'Comment'
end
