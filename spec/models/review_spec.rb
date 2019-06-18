# == Schema Information
#
# Table name: reviews
#
#  id                  :bigint           not null, primary key
#  product_name        :string(255)      not null
#  content             :text(65535)      not null
#  picture             :string(255)
#  price               :integer
#  rating              :integer          not null
#  stamp_count         :integer          default(0)
#  user_id             :bigint
#  store_id            :bigint
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  product_category_id :bigint
#

require 'rails_helper'

RSpec.describe Review, type: :model, focus: true do
  describe 'バリデーションのテスト' do
    # product_name
    it { is_expected.to validate_presence_of :product_name }
    it { is_expected.to validate_length_of(:product_name).is_at_least(4) }
    # content
    it { is_expected.to validate_presence_of :content }
    it { is_expected.to validate_length_of(:content).is_at_most(500) }
    # rating
    it { is_expected.to validate_presence_of :rating }
    it { is_expected.to validate_inclusion_of(:rating).in_range(1..10) }
  end

  describe '#recent' do
    before do
      10.times do
        FactoryBot.create(:review)
      end
    end

    it '新着順にreviewを取得すること' do
      expect(10).to eq 10
    end
  end
end
