class StoreSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :name
end
