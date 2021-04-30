class StakeAddressSerializer
  include JSONAPI::Serializer
  attributes :view
  # has_many :epoch_stakes
end