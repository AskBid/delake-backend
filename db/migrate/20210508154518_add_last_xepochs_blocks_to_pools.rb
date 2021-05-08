class AddLastXepochsBlocksToPools < ActiveRecord::Migration[6.1]
  def change
    add_column :pools, :last_xepochs_blocks, :integer
  end
end
