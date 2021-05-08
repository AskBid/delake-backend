class AddAvgBlocksStatusToPoolEpoches < ActiveRecord::Migration[6.1]
  def change
    add_column :pool_epoches, :avg_blocks, :float
  end
end
