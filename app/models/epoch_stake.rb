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

	def epoch_info
		# Block.epoch(257).last.epoch_slot_no
		# the above could be used to calculate the progress percentage of the epoch
		# atm is being calcualted from date at the front end
		{current_epoch: Block.current_epoch}
	end

	def calc_rewards(pool_hash = self.pool_hash)
		# rewards are known for epochs -2 from current epoch, therefore no need of calculation if < -2
		# if < -2 we just query the rewards that are already calculated on chain
		if epoch_no > (Block.current_epoch - 2)
			rewards = pool_hash.calc_rewards(self.epoch_no)
			if rewards
				((self.amount/1000000) / pool_hash.size(self.epoch_no)).to_f * rewards
			else
				nil
			end
		else
			pool_hash === self.pool_hash ? self.rewards : self.compare_rewards(pool_hash)
		end
	end

	def rewards
		reward = Reward.where(addr_id: self.addr_id).where(epoch_no: self.epoch_no).first
		if reward
			reward = reward.amount.to_f / 1000000
		end
		reward
	end

	def compare_rewards(pool_hash)
		# used for epochs where rewards are already sent to compare 'would be' delegation to other pool
		pool_param = pool_hash.pool_updates.epoch(epoch_no).latest
		margin = pool_param[:margin]
		cost = pool_param[:fixed_cost]
		pool_whole_rewards = pool_hash.rewards.epoch(self.epoch_no).sum(:amount)
		pool_rewards = ((pool_whole_rewards - (pool_param[:fixed_cost])) * (1 - pool_param[:margin])) / 1000000
		((self.amount/1000000) / pool_hash.size(self.epoch_no)).to_f * pool_rewards
	end

	def blocks
		self.pool_hash.blocks.epoch(self.epoch_no).count
	end

	def estimated_blocks
		(self.pool_hash.size(self.epoch_no) / (EpochStake.total_staked(self.epoch_no)/1000000)) * 21600
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
