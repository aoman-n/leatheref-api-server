require 'rails_helper'

RSpec.describe 'Reviews', type: :request, focus: true do
  describe 'レビューのリクエストスペック' do
    let(:user) { FactoryBot.create(:user) }

    before do
      @stores = Store.all
      @product_categories = ProductCategory.all
    end

    it '有効なパラメータならレビューを作成出来ること' do
      token = log_in_as(user)
      review_params = {
        product_name: "test name",
        content: "sample review content",
        price: 1000,
        rating: 5,
        store_id: @stores[0].id,
        product_category_id: @product_categories[0].id,
      }
      expect do
        post reviews_path, headers: generate_login_header(token), params: review_params
      end.to change(Review, :count).by(1)
      expect(response).to have_http_status '201'
    end
  end
end
