class SlotLeader < DbSyncRecord
	self.table_name = 'slot_leader'
	self.ignored_columns = %w(hash)

	has_one :block
	belongs_to :pool_hash
end
