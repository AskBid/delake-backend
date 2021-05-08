class ChangeLastXepochsBlocks < ActiveRecord::Migration[6.1]
  def change
    rename_column :pools, :last_xepochs_blocks, :producing_epochs
  end
end
