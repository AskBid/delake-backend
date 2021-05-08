class ChangePerformanceToBeFloatInPools < ActiveRecord::Migration[6.1]
  def change
  	change_column :pools, :performance, :float
  end
end
