class EpochStakeDefaultSerializer
  # include JSONAPI::Serializer
  # attributes :epoch_no, :amount
 	# attributes :stake_address, foreign_key: :addr_id
	# attributes :pool_hash, foreign_key: :pool_id
  # belongs_to :stake_address, id_method_name: :addr_id
  # belongs_to :pool_hash
  def initialize(epoch_stake)
    @epoch_stake = epoch_stake
  end

  def to_live_rewards_json
    options = {include: [
				stake_address: {
					only: [:id, :view],
				},
				pool_hash: {
					only: [:id, :view], 
					include: [pool: {
						only: [:id, :ticker, :url]}
					]
				}
			],
			only: [:id, :amount, :epoch_no],
			methods: [
				:calc_rewards, 
				:blocks, 
				:estimated_blocks, 
				:epoch_info
			]}
    @epoch_stake.to_json(options)
  end
end