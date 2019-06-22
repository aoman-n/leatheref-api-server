CONFIG[:stores].each { |n| Store.create!({ name: n }) }

CONFIG[:product_categories].each { |n| ProductCategory.create!({ name: n }) }
