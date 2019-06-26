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

require 'rails_helper'

RSpec.describe Comment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
