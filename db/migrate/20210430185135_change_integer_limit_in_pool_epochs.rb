class ChangeIntegerLimitInPoolEpochs < ActiveRecord::Migration[6.1]
  def change
  	change_column :pool_epoches, :size, :integer, limit: 8
  	change_column :pool_epoches, :total_stakes, :integer, limit: 8
  end
end
