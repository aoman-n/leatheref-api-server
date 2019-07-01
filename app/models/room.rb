class Room < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :users, through: :entries
  has_many :direct_messages, dependent: :destroy

  # 最新のメッセージ1件を取得するためのアソシエーション定義
  has_one :newest_message, -> {
    order(updated_at: :desc)
  }, class_name: 'DirectMessage'

  def current_user_exists?
    entries.exists?(user_id: current_user.id)
  end
end
