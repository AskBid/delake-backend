class Pool < ApplicationRecord
	belongs_to :pool_hash
	
	validates_uniqueness_of :pool_hash_id, message: "%{value} already exist"

	

	private

	def optimal_reward(epoch_no = Block.current_epoch)
		ep = EpochParam.find_by({epoch_no: epoch_no})
		(ep._R / (1 + ep[:influence])) * fso2(ep) if ep
	end

	def fso2(ep)
		o1 = self.pool_hash.size(ep[:epoch_no]) / ep._T
		s1 = (self.pool_hash.pool_updates.epoch(ep[:epoch_no]).latest[:pledge] / 1000000) / ep._T
		z0 = 1 / (ep[:optimal_pool_count] * ep._T)
		a0 = ep[:influence]
		bigRatio = (o1-(s1*((z0-o1)/z0)))/z0
		o1+((s1*a0)*bigRatio)
	end

	def apparent_pool_performance
	end
end
