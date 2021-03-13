class Pool < ApplicationRecord
	belongs_to :pool_hash
	attr_reader :pool_size
	
	validates_uniqueness_of :pool_hash_id, message: "%{value} already exist"

	def calc_rewards(epoch_no = Block.current_epoch, whole = false)
		ep = EpochParam.find_by({epoch_no: epoch_no})
		@pool_size = self.pool_hash.size(ep[:epoch_no]) 
		pool_param = self.pool_hash.pool_updates.epoch(epoch_no).latest
		rewards = (optimal_reward(ep, pool_param) * apparent_pool_performance(ep)) if ep
		if !whole && ep
			rewards = (rewards - (pool_param[:fixed_cost]/1000000)) * (1 - pool_param[:margin])
		end
		rewards.to_i
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
		_B = self.pool_hash.blocks.epoch(ep[:epoch_no]).count / (21600 * (1 - ep[:decentralisation])).to_f
		oa = self.pool_size/ (EpochStake.total_staked(ep[:epoch_no]) / 1000000)
		_B/oa
	end
end