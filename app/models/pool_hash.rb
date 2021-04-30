class PoolHash < DbSyncRecord
	#This is the actual Pool identity and Table on the cardano-db-sync
	#Connects to local DB Table Pool which holds scrapes Tickers
	attr_reader :pool_size
	self.ignored_columns = %w(hash_raw)

	self.table_name = 'pool_hash'
	has_many :rewards, foreign_key: :pool_id
	has_many :epoch_stakes, foreign_key: :pool_id
	has_many :delegations, foreign_key: :pool_hash_id
	has_one :pool
	has_many :pool_updates, foreign_key: :hash_id
	has_many :slot_leader
	has_many :blocks, through: :slot_leader
	has_many :user_pool_hashes
	has_many :pool_epoch
	# has_many :users, through: :user_pool_hashes

	# can't use because hash_raw ingored to be working with serializers
	# def hash_hex
	# 	self.class.bin_to_hex(self[:hash_raw])
	# end

	def self.by_user(user)
		PoolHash.where(id:  user.user_pool_hashes.pluck(:pool_hash_id))
	end

	def self.bin_to_hex(s)
	  s.unpack('H*').first
	end

	def size(epochNo)
		(self.epoch_stakes
			.epoch(epochNo)
			.sum('amount')
			.to_i) / 1000000
	end

	def calc_rewards(epoch_no = Block.current_epoch, minus_pool_costs = true)
		# whole is to get all rewards without taking away the Pool costs and margins
		ep = EpochParam.find_by({epoch_no: epoch_no})
		@pool_size = self.size(ep[:epoch_no]) 
		pool_param = self.pool_updates.epoch(epoch_no).latest
		if ep && !(pool_param === [])
			rewards = (optimal_reward(ep, pool_param) * apparent_pool_performance(ep)) 
		else
			return nil
		end
		if minus_pool_costs && ep
			rewards = (rewards - (pool_param[:fixed_cost]/1000000)) * (1 - pool_param[:margin])
		end
		if rewards && rewards > 0
			rewards.to_i
		else
			0
		end
	end

	private
	#for a video explanation of the formulas https://www.youtube.com/watch?v=0S5R2boqYLc
	#for an article explaining the formulas https://viperstaking.com/ada-pools/expected-epoch-blocks
	def optimal_reward(ep, pool_param)
		_R = ep._R
		o1 = self.pool_size / ep._T.to_f
		s1 = (pool_param[:pledge] / 1000000) / ep._T.to_f
		z0 = (1.0 / ep[:optimal_pool_count]) * ep._T
		a0 = ep[:influence]
		bigRatio = (o1-(s1*((z0-o1)/z0)))/z0
		fso2 = o1+((s1*a0)*bigRatio)
		(_R/(1 + a0)) * fso2
	end

	def apparent_pool_performance(ep)
		_B = self.blocks.epoch(ep[:epoch_no]).count / (21600 * (1 - ep[:decentralisation])).to_f
		oa = self.pool_size/ (EpochStake.total_staked(ep[:epoch_no]) / 1000000)
		_B/oa
	end
end