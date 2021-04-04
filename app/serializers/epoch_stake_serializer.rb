class EpochStakeSerializer
  include JSONAPI::Serializer
  attributes :epoch_no, :amount
  attributes :stake_address, foreign_key: :addr_id
	attributes :pool_hash, foreign_key: :pool_id
  # has_many :epoch_stakes
end