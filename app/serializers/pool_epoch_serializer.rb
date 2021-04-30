class PoolEpochSerializer
  include JSONAPI::Serializer
  attributes :blocks, :total_stakes, :size
  belongs_to :pool_hash
end