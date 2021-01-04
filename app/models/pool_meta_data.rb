class PoolMetaData < DbSyncRecord
	self.table_name = 'pool_meta_data'
	has_one :pool_update, foreign_key: :meta_id

	self.ignored_columns = %w(hash)
end
