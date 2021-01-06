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
		rejects = {rejects: []}

		self.all.map do |pool_hash|
			size = pool_hash.size(epochNo)
			print pool_hash.id
			print "\r"
			if pool_hash.pool
				pool_hash.pool.epoch_pool_sizes.build(size: size, epochno: epochNo)
				pool_hash.pool.save
			else
				rejects[:rejects] << pool_hash.view
				print "       !!!!!! NO POOL for #{pool_hash.view}"
				print "\r"
			end
		end

		rejects
	end
end
