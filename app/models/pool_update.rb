class PoolUpdate < DbSyncRecord
	self.table_name = 'pool_update'
	belongs_to :pool_meta_data, foreign_key: :meta_id
	belongs_to :pool_hash, foreign_key: :hash_id
end
