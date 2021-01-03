class UtxoView < DbSyncRecord
	self.table_name = 'utxo_view'
	belongs_to :stake_address
end
