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

  QUERIES = {
    'seven' => 'セブン-イレブン',
    'lawson' => 'ローソン',
    'family' => 'ファミリーマート',
  }.freeze

  def self.get_seven_id
    Store.get_record('seven').id
  end

  def self.get_lawson_id
    Store.get_record('lawson').id
  end

  def self.get_family_id
    Store.get_record('family').id
  end

  def self.get_record(store_name)
    Store.find_by(name: QUERIES[store_name])
  end
end
