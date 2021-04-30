class EpochStakeSerializer
  include JSONAPI::Serializer
  attributes :pool_id, :epoch_no, :amount
end
# <EpochStake 
# id: 407809, 
# addr_id: 96857, 
# pool_id: 1281, 
# amount: 0.2726167e7, 
# epoch_no: 220>