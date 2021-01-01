class StakeAddress < ApplicationRecord
	self.table_name = 'stake_address'
	has_many :rewards, foreign_key: :addr_id
	has_many :delegations, foreign_key: :addr_id
	has_many :utxo_views, foreign_key: :stake_address_id
end
