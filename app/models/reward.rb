class Reward < DbSyncRecord
	# returns all the rewards returned to the pool, including pledge/owner rewards 
	# and including cost and margin pool fee
	self.table_name = 'reward'
	self.ignored_columns = %w(type)
	belongs_to :stake_address, foreign_key: :addr_id
	belongs_to :pool_hash, foreign_key: :pool_id

	scope :epoch, -> (epoch_no) {where("epoch_no = ?", epoch_no)} 
end
