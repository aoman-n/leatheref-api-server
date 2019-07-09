ActiveRecord::Base.transaction do
  CONFIG[:stores].each { |n| Store.create!({ name: n }) } if Store.all.empty?
  CONFIG[:product_categories].each { |n| ProductCategory.create!({ name: n }) } if ProductCategory.all.empty?
  CONFIG[:reactions].each { |n| Reaction.create!({ name: n }) } if Reaction.all.empty?

  if Rails.env.development? && Review.all.empty?
    stores = Store.all
    product_categories = ProductCategory.all
    5.times do |i|
      user = User.create!(
        login_name: "user#{i}",
        email: "user#{i}@example.com",
        password: 'password',
        activated: true,
        image_url: 'https://s3-ap-northeast-1.amazonaws.com/aohiro-blog/User/avatar/dot.jp',
      )
      user.reviews.create!(
        product_name: "商品名#{i}",
        content: "テストレビュー#{i}",
        price: 100,
        rating: i + 1,
        store_id: stores.sample.id,
        product_category_id: product_categories.sample.id,
      )
    end
  end
end
