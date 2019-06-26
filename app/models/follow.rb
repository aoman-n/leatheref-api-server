# == Schema Information
#
# Table name: follows
#
#  id             :bigint           not null, primary key
#  user_id        :bigint
#  target_user_id :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Follow < ApplicationRecord
  belongs_to :user
  belongs_to :target_user, class_name: "User"

  validates :user_id, presence: true
  validates :target_user_id, presence: true
end
