class Delegation < DbSyncRecord
	# those are only the new delegations that became effective on this epoch
	# the epoch refers to the epoch in which the delegation was effective for the blocks lottery
	# effective epoch = epoch of transaction + 2
	# active_epoch_no
	# this only records the delegation registration, not the amount which is instead in EpochStake

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

	def self.epoch_flow(epochNo)
		epoch_delegations = Delegation.epoch(epochNo)

		from_pools = epoch_delegations.map do |delegation|
			pool = delegation.from_pool
			if pool
				delegation.from_pool.id
			else
				'new_delegation'
			end
		end

		to_pools = epoch_delegations.select('distinct(pool_hash_id)').map{ |d| d.pool_hash_id }
		from_table = {}
		table = {}

		(from_pools + to_pools).each do |pool_hash_id|
			from_table[pool_hash_id] = 0
		end

		from_table.each do |pool_hash_id, nil_placeholder_value|
			if pool_hash_id.is_a?(Integer)
				ph = PoolHash.find_by_id(pool_hash_id)
				size = ph.size(epochNo)
				ticker = ph.pool.ticker if ph.pool
			end
			table[pool_hash_id] = {from: from_table.clone, size: nil, ticker: 'new_delegation'}
		end

		delegations_by_pool = epoch_delegations.group_by(&:pool_hash_id)
		delegations_by_pool.each do |pool_hash, delegations|
			delegations.each do |delegation|
				from_id = 'new_delegation'
				pool = delegation.from_pool
				if pool
						from_id = delegation.from_pool.id
				end
				puts delegation
				begin
					value = table[pool_hash][:from][from_id]
					value += (delegation.stake_address.epoch_stakes.epoch(240).first.amount / 1000000)
					table[pool_hash][:from][from_id] += value
				rescue
					puts "#{delegation.stake_address} has a delegation but is probably not active or de-regidtered stake"
					puts "no epoch_stake could be found so no amount was added."
					puts "check if that's the case or perhaps was a different error and an amount skipped."
				end
			end
		end
		binding.pry
		table
	end

end
