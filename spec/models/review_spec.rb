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

  describe 'scope' do
    before :all do
      @stores = Store.all
      @product_categories = ProductCategory.all
    end

    describe 'store_with' do
      let!(:seven_review) { FactoryBot.create(:review, store_id: Store.get_seven_id) }
      let!(:lawson_review) { FactoryBot.create(:review, store_id: Store.get_lawson_id) }
      let!(:family_review) { FactoryBot.create(:review, store_id: Store.get_family_id) }

      it 'セブン-イレブンのレビューが取得されること' do
        reviews = Review.store_with('seven')
        expect(reviews).to include seven_review
      end

      it 'ローソンのレビューが取得されること' do
        reviews = Review.store_with('lawson')
        expect(reviews).to include lawson_review
      end9

      it 'ファミマのレビューが取得されること' do
        reviews = Review.store_with('family')
        expect(reviews).to include family_review
      end
    end

    describe 'category_with' do
      it '指定したカテゴリーのレビューが取得されること' do
      end
    end
  end
end
