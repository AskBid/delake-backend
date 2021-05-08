class AddAvgBlocksStatusToPools < ActiveRecord::Migration[6.1]
  def change
    add_column :pools, :avg_blocks, :float
  end
end
