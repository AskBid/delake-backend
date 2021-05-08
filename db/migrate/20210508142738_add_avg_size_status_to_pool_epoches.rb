class AddAvgSizeStatusToPoolEpoches < ActiveRecord::Migration[6.1]
  def change
    add_column :pool_epoches, :avg_size, :float
  end
end
