class AddBlocksDeltaPcToPoolEpoches < ActiveRecord::Migration[6.1]
  def change
    add_column :pool_epoches, :blocks_delta_pc, :float
  end
end
