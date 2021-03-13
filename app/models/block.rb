class Block < DbSyncRecord
	self.table_name = 'block'
	self.ignored_columns = %w(hash)
	has_many :txs
	belongs_to :slot_leader
	belongs_to :pool_hash
	# SELECT epoch_no FROM block WHERE block_no IS NOT NULL ORDER BY epoch_no DESC LIMIT 1;
	# scope :last_block, -> {where("block_no IS NOT NULL").order(epoch_no: :desc).limit(1)}
	scope :epoch, -> (epoch_no) {where("epoch_no = ?", epoch_no)}

	def epoch_param
		EpochParam.find_by({epoch_no: self.epoch_no})
	end

	def self.current_epoch
		Block.last.epoch_no
	end
end
