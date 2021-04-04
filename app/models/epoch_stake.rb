class EpochStake < DbSyncRecord
	# those are active_delegation, so all the delegations that are effective this epoch, old and new
	# the epoch refers to the epoch in which the delegation was effective for the blocks lottery
	# effective epoch = epoch of transaction + 2
	# this records the stake amount unlike delegation that only holds the registration of the delegation
	self.table_name = 'epoch_stake'
	belongs_to :stake_address, foreign_key: :addr_id
	belongs_to :pool_hash, foreign_key: :pool_id

	scope :epoch, -> (epochno) {where('epoch_no = ?', epochno)}
	scope :by_addr_id, -> (addr_id) {where('addr_id = ?', addr_id)}

	def self.total_staked(epochno)
		self.epoch(epochno).sum("amount")
	end

	def calc_rewards(pool_hash = self.pool_hash)
		# rewards are known for epochs -2 from current epoch, therefore no need of calculation if < -2
		# if < -2 we just query the rewards taht are already calculated on chain
		if epoch_no > (Block.current_epoch - 2)
			rewards = pool_hash.calc_rewards(self.epoch_no)
			total_stakes = pool_hash.size(self.epoch_no)
			puts self.amount/1000000
			((self.amount/1000000) / total_stakes).to_f * rewards
		else
			rewards
		end
	end

	def rewards
		#to be written
	end

	def previous
		EpochStake.by_addr_id(self.addr_id)
			.where('epoch_no < ?', self.epoch_no)
			.order(epoch_no: :desc).first
	end

	def delta 
		if self.previous
			self.amount - self.previous.amount
		else 
			self.amount
		end
	end
end
