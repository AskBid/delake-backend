class PoolHashSerializer
  include JSONAPI::Serializer
  attributes :view
  has_one :pool
end