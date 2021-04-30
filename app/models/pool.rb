class Pool < ApplicationRecord
	belongs_to :pool_hash
	has_many :pool_epoch 
	
	validates_uniqueness_of :pool_hash_id, message: "%{value} already exist"
end