class Pool < ApplicationRecord
	belongs_to :pool_hash
	has_many :epoch_pool_sizes
	
	validates_uniqueness_of :pool_hash_id, message: "%{value} already exist"
end
