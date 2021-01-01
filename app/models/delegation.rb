class Delegation < ApplicationRecord
	self.table_name = 'delegation'
	belongs_to :stake_address
end
