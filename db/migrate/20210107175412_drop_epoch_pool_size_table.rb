class DropEpochPoolSizeTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :epoch_pool_sizes
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
