class Room < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :users, through: :entries
  has_many :direct_messages, dependent: :destroy

  # 最新のメッセージ1件を取得するためのアソシエーション定義
  has_one :newest_message, -> {
    order(updated_at: :desc)
  }, class_name: 'DirectMessage'

  def user_exists?(target_user)
    entries.exists?(user_id: target_user.id)
  end
end
