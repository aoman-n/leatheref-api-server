RSpec.shared_context "setup product_category" do
  CONFIG[:product_categories].each { |n| ProductCategory.create!({ name: n }) }
end
