class PoolHash < DbSyncRecord
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
end
