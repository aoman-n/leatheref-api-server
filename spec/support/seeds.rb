RSpec.configure do |config|
  config.before(:suite) do
    # CONFIG[:stores].each { |n| Store.create!({ name: n }) }
    # CONFIG[:product_categories].each { |n| ProductCategory.create!({ name: n }) }
    # p 'insert initial data!'
  end

  config.after(:suite) do
    # DatabaseCleaner.clean
  end
end
