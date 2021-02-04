class EpochStake < DbSyncRecord
	# those are active_delegation, so all the delegations that are effective this epoch, old and new
	# the epoch refers to the epoch in which the delegation was effective for the blocks lottery
	# effective epoch = epoch of transaction + 2
	# this records the stake amount unlike delegation that only holds the registration of the delegation
	self.table_name = 'epoch_stake'
	belongs_to :stake_address, foreign_key: :addr_id
	belongs_to :pool_hash, foreign_key: :pool_id

	scope :epoch, -> (epochno) {where('epoch_no = ?', epochno)}

	def self.total_staked(epochno)
		self.epoch(epochno).map{|stake| stake.amount}.inject(0){|sum,amount| sum + amount}
	end

	def delta
		
	end
end
