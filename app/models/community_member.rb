class CommunityMember < ApplicationRecord
  belongs_to :member, class_name: "User"
  belongs_to :community
end
