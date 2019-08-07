class JoinRequest < ApplicationRecord
  belongs_to :user
  belongs_to :community

  validates :message, presence: true, length: { maximum: 300 }
  validates :status, presence: true
  # validates :community_id, uniqueness: { scope: :member_id }
  validate :reject_community_member_request

  enum status: { unchecked: 0, accept: 1, reject: 2 }, _prefix: true

  scope :recent, -> { order(created_at: :desc) }
  scope :filter_status, -> (status) {
    where(status: status)
  }
  scope :filter_community, -> (id) {
    where(community_id: id)
  }

  private

  def reject_community_member_request
    if community.community_members.any? { |m| m.member_id == user_id }
      errors.add(:member_id, 'はすでに存在しています。')
    end
  end
end
