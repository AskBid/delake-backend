class PoolSerializer
  include JSONAPI::Serializer
  attributes :ticker, :homepage
end
# <Pool 
# id: 36, 
# ticker: "OCTAS", 
# url: "https://raw.githubusercontent.com/Octalus/cardano/...", 
# pool_hash_id: 1, 
# created_at: "2021-04-19 19:47:11.457375000 +0000", 
# updated_at: "2021-04-19 19:49:33.743975000 +0000", 
# hash_hex: "ca7d12decf886e31f5226b5946c62edc81a7e40af95ce7cd64...", 
# pool_addr: "pool1z5uqdk7dzdxaae5633fqfcu2eqzy3a3rgtuvy087fdld7...", 
# description: "Octa's Performance Pool", 
# name: "OctasPool", 
# homepage: "https://octaluso.dyndns.org"