class Block < DbSyncRecord
	self.table_name = 'block'
	self.ignored_columns = %w(hash)
	# SELECT epoch_no FROM block WHERE block_no IS NOT NULL ORDER BY epoch_no DESC LIMIT 1;
	# scope :last_block, -> {where("block_no IS NOT NULL").order(epoch_no: :desc).limit(1)}

	def self.current_epoch
		Block.last.epoch_no
	end
end
