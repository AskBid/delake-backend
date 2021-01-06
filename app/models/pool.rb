class Pool < ApplicationRecord
	belongs_to :pool_hash
	validates_uniqueness_of :pool_hash_id, message: "%{value} already exist"
end
