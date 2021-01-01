class Reward < ApplicationRecord
	self.table_name = 'reward'
	belongs_to :stake_address
	belongs_to :pool_hash
end
