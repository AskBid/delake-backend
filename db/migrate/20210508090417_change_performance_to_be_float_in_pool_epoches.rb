class ChangePerformanceToBeFloatInPoolEpoches < ActiveRecord::Migration[6.1]
  def change
  	change_column :pool_epoches, :performance, :float
  end
end
