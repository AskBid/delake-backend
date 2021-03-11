class Tx < DbSyncRecord
	self.table_name = 'tx'
	self.ignored_columns = %w(hash)

	belongs_to :block

	scope :epoch, -> (epoch_no) {joins(:block).where("epoch_no = ?", epoch_no)}
	scope :fees, -> {sum('fee')}

	def self.current_supply
		query = <<-SQL
			select sum (value) / 1000000 as current_supply from tx_out as tx_outer where
    	not exists
      ( select tx_out.id from tx_out inner join tx_in
          on tx_out.tx_id = tx_in.tx_out_id and tx_out.index = tx_in.tx_out_index
          where tx_outer.id = tx_out.id
      ) ;
		SQL
		DbSyncRecord.connection.exec_query(query).to_a.first["current_supply"].to_i
	end
end
