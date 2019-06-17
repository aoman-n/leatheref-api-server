# == Schema Information
#
# Table name: stores
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Store, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
