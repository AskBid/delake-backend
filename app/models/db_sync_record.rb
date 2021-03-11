class DbSyncRecord < ActiveRecord::Base
  self.abstract_class = true
  establish_connection DB_SYNC_DB
  # DB_SYNC_DB is defined in `config/initializers/db_sync_database.rb`

  def self.supply(epoch_no)
  	er = EpochRecord.find_by(epoch_no: epoch_no)
  	if er
  		er[:supply]
  	else
  		current_supply = Tx.current_supply
  		EpochRecord.create(epoch_no: epoch_no, supply: current_supply)
  		current_supply
  	end
  end
end
