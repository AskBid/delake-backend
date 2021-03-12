class PoolUpdate < DbSyncRecord
	self.table_name = 'pool_update'
	belongs_to :pool_meta_data, foreign_key: :meta_id
	belongs_to :pool_hash, foreign_key: :hash_id

	scope :latest, -> { order(active_epoch_no: :DESC).limit(1).first }
	scope :epoch, -> (epoch_no) { where("active_epoch_no <= ?", epoch_no) }
end
