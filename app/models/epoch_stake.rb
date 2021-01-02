class EpochStake < ApplicationRecord
	# those are active_delegation, so all the delegations that are effective this epocj, old and new
	# the epoch refers to the epoch in which the delegation was effective for the blocks lottery
	# effective epoch = epoch of transaction + 2
	self.table_name = 'epoch_stake'
	belongs_to :stake_address, foreign_key: :addr_id
	belongs_to :pool_hash, foreign_key: :pool_id
end
