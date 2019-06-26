class ProductCategorySerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :name
end
