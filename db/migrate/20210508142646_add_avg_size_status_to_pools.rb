class AddAvgSizeStatusToPools < ActiveRecord::Migration[6.1]
  def change
    add_column :pools, :avg_size, :float
  end
end
