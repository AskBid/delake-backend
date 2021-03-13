class Reward < DbSyncRecord
	self.table_name = 'reward'
	belongs_to :stake_address, foreign_key: :addr_id
	belongs_to :pool_hash, foreign_key: :pool_id

	scope :epoch, -> (epoch_no) {where("epoch_no = ?", epoch_no)} 
end
