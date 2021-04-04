class StakeAddress < DbSyncRecord
	#pool_owner Table on cardano-db-sync records the stake address without 1e
	#if in pool_owner the address is: \x0e5b086df87a2a0c5c398b41d413f84176c527da5e5cb641f4598844
	#in stake_address the address is: \xe10e5b086df87a2a0c5c398b41d413f84176c527da5e5cb641f4598844
	#there is usually more than one pool_owner, but in reality there is only one per pool. 
	#You can find which one is last by checking the tx=>block=>epoch
	self.table_name = "stake_address"
	self.ignored_columns = %w(hash_raw)
	# self.table_name = "#{self.connection.current_database}.stake_address"
	has_many :rewards, foreign_key: :addr_id
	has_many :delegations, foreign_key: :addr_id
	has_many :epoch_stakes, foreign_key: :addr_id
	has_many :utxo_views, foreign_key: :stake_address_id
	has_many :user_stakes
	# below association wouldn't work because of the tables being in to different databases
	# has_many :users, through: :user_stakes

	def self.by_user(user)
		StakeAddress.where(id:  user.user_stakes.pluck(:stake_address_id))
	end
end
