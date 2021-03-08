class Tx < DbSyncRecord
	self.table_name = 'tx'
	self.ignored_columns = %w(hash)

	belongs_to :block

	scope :epoch, -> (epoch_no) {joins(:block).where("epoch_no = ?", epoch_no)}
	scope :fees, -> {sum('fee')}
end
