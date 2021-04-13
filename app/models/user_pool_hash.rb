class UserPoolHash < ApplicationRecord
	belongs_to :user
	belongs_to :pool_hash

	validates_uniqueness_of :user_id, scope: [:pool_hash_id]
end
