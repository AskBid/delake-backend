class UserStake < ApplicationRecord
	belongs_to :user
	belongs_to :stake_address
	# self.table_name = "#{self.connection.current_database}.user_stakes"
	self.table_name = "user_stakes"

	validates_uniqueness_of :user_id, scope: :stake_address_id
end
