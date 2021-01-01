class Delegation < ApplicationRecord
	self.table_name = 'delegation'
	belongs_to :stake_address
	belongs_to :pool_hash
end
