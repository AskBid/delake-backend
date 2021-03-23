class UserSerializer
  include JSONAPI::Serializer
  # binding.pry
  attributes :username, :id
end