class CreateEpochPoolSizes < ActiveRecord::Migration[6.0]
  def change
    create_table :epoch_pool_sizes do |t|
      t.integer :size
      t.integer :epochno
      t.integer :pool_id

      t.timestamps
    end
  end
end
