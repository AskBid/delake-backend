class Pool < ApplicationRecord
	belongs_to :pool_hash
	attr_reader :pool_size
	
	validates_uniqueness_of :pool_hash_id, message: "%{value} already exist"

	def calc_rewards(epoch_no = Block.current_epoch, whole = false)
		ep = EpochParam.find_by({epoch_no: epoch_no})
		@pool_size = self.pool_hash.size(ep[:epoch_no]) 
		rewards = (optimal_reward(ep) * apparent_pool_performance(ep)) if ep
		if !whole
			pool_param = self.pool_hash.pool_updates.epoch(epoch_no).latest
			rewards = (rewards - (pool_param[:fixed_cost]/1000000)) * (1 - pool_param[:margin])
		end
		rewards.to_i
	end

	private
	#for a video explanation of the formulas https://www.youtube.com/watch?v=0S5R2boqYLc
	#for an article explaining the formulas https://viperstaking.com/ada-pools/expected-epoch-blocks
	def optimal_reward(ep, a0)
		(ep._R / (1 + ep[:influence])) * fso2(ep,a0)
	end

	def fso2(ep,a0)
		o1 = self.pool_size / ep._T.to_f
		s1 = (self.pool_hash.pool_updates.epoch(ep[:epoch_no]).latest[:pledge] / 1000000) / ep._T.to_f
		z0 = (1 / ep[:optimal_pool_count].to_f) * ep._T
		bigRatio = (o1-(s1*((z0-o1)/z0)))/z0
		o1+((s1*a0)*bigRatio)
	end

	def apparent_pool_performance(ep)
		_B = self.pool_hash.blocks.epoch(ep[:epoch_no]).count / (21600 * (1 - ep[:decentralisation])).to_f
		oa = self.pool_size/ (EpochStake.total_staked(ep[:epoch_no]) / 1000000)
		_B/oa
	end
end