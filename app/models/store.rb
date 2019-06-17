# == Schema Information
#
# Table name: stores
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Store < ApplicationRecord
  has_many :reviews

  validates :name, uniqueness: true, presence: true
end
