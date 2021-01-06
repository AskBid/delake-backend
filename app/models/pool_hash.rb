class PoolHash < DbSyncRecord
	#This is the actual Pool identity and Table on the cardano-db-sync
	#Connects to local DB Table Pool which holds scrapes Tickers

	self.table_name = 'pool_hash'
	has_many :rewards, foreign_key: :pool_id
	has_many :epoch_stakes, foreign_key: :pool_id
	has_many :delegations, foreign_key: :pool_hash_id
	has_one :pool
	has_many :pool_updates, foreign_key: :hash_id

	def hash_hex
		self.class.bin_to_hex(self[:hash_raw])
	end

	def self.bin_to_hex(s)
	  s.unpack('H*').first
	end

	def size(epochNo)
		(epoch_stakes
			.epoch(epochNo)
			.reduce(0) { |sum, num| sum + num[:amount] }
			.to_i) / 1000000
	end

	def self.sizes(epochNo)
		self.all.map do |pool_hash|
			puts pool_hash.id
			size = pool_hash.size(epochNo)
			if pool_hash.pool && size > 1000
				pool_hash.pool.epoch_pool_size.build(size: size)
				# { ticker: pool_hash.pool.ticker, size: size, poolid: pool_hash.view } 
			else
				#usually if not pool_hash.pool is because the pool doesn't have a pool_meta_data
				puts "!!!!!! NO POOL for #{pool_hash.view}"if !pool_hash.pool
			end
		end
	end
end
