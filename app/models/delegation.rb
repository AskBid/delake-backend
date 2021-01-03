class Delegation < DbSyncRecord
	# those are only the new delegations that became effective on this epoch
	# the epoch refers to the epoch in which the delegation was effective for the blocks lottery
	# effective epoch = epoch of transaction + 2
	# active_epoch_no

	self.table_name = 'delegation'
	belongs_to :stake_address, foreign_key: :addr_id
	belongs_to :pool_hash

	scope :epoch, -> (epochno) {where('active_epoch_no = ?', epochno)}

	def from_pool
		pre_pool = self.stake_address
			.delegations
			.where('active_epoch_no < ?', self.active_epoch_no)
			.order(active_epoch_no: :desc).first
		if pre_pool
			pre_pool.pool_hash
		else
			nil
		end
	end
	
end
