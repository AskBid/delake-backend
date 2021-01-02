class PoolHash < ApplicationRecord
	self.table_name = 'pool_hash'
	has_many :rewards, foreign_key: :pool_id
	has_many :epoch_stakes, foreign_key: :pool_id
	has_many :delegations, foreign_key: :pool_hash_id
end
