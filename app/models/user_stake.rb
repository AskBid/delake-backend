class UserStake < ApplicationRecord
	belongs_to :user
	belongs_to :stake_address
	# self.table_name = "#{self.connection.current_database}.user_stakes"
	self.table_name = "user_stakes"
end
