class UserPoolHash < ApplicationRecord
	belongs_to :user
	belongs_to :pool_hash
end
