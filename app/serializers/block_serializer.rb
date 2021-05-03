class BlockSerializer
  include JSONAPI::Serializer
  attributes :time, :epoch_no, :slot_no, :block_no, :epoch_slot_no
  # has_many :epoch_stakes
end
# Block 
# id: 4748306, 
# epoch_no: 220, 
# slot_no: 9676800, 
# epoch_slot_no: 0, 
# block_no: 4746128, 
# previous_id: 4748305, 
# slot_leader_id: 4492689, 
# size: 426, 
# time: "2020-09-27 21:44:51.000000000 +0000", 
# tx_count: 1, 
# proto_major: 2, 
# proto_minor: 0, 
# vrf_key: "vrf_vk1dkfsejw3h2k7tnguwrauqfwnxa7wj3nkp3yw2yw3400...", 
# op_cert: "\xFE\xDF\xBE\x7Ftr\xA8\xFA\xDC\xE0\x89\e\x89M\xA9\x1D\xEFRn\xE8\xDF\x92\xE0&1\x89\xE2\x8E\x81\xEB\xDA\x18"