class DbSyncRecord < ActiveRecord::Base
  self.abstract_class = true
  establish_connection DB_SYNC_DB
  # DB_SYNC_DB is defined in `config/initializers/db_sync_database.rb`

  def self.supply(epoch_no)
    er = EpochRecord.find_by(epoch_no: epoch_no)
  	if !er
      er = EpochRecord.create_by(epoch_no: epoch_no)
  		er.update(supply: self.current_supply)
    elsif !er.supply
      er.update(supply: self.current_supply)
    end
    er.supply
  end

  private

  def self.current_supply
    current_supply = UtxoView.sum('value') + Reserve.sum('amount') + Reward.sum('amount') - Withdrawal.sum('amount')
    current_supply/1000000
  end
end
