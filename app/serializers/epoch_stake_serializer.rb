class EpochStakeSerializer
  include JSONAPI::Serializer
  attributes :epoch_no, :amount
 #  attributes :stake_address, foreign_key: :addr_id
	# attributes :pool_hash, foreign_key: :pool_id
  belongs_to :stake_address#, id_method_name: :addr_id
  # belongs_to :pool_hash
end