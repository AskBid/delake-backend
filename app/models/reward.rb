class Reward < ApplicationRecord
	self.table_name = 'reward'
	belongs_to :stake_address
end
