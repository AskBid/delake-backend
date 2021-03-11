class EpochParam < DbSyncRecord
	self.table_name = 'epoch_param'

  def _R
  	_T = self.class.supply(self[:epoch_no])
  	_Re = (45000000000 - _T) * self[:monetary_expand_rate]
  	_R = _Re * (1 - self[:treasury_growth_rate])
  end
end
