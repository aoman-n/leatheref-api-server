class UserSerializer
  include FastJsonapi::ObjectSerializer

  attributes :display_name, :image_url
end
