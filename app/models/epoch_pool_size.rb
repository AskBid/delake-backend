class EpochPoolSize < ApplicationRecord
	belongs_to :pool
 
	validates_uniqueness_of :pool_id,  scope: [:epochno], message: "%{value} already exist for this :epochno"

	scope :epoch, -> (epochno) {where('epochno = ?', epochno)}
end