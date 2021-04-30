class CreatePoolEpoches < ActiveRecord::Migration[6.1]
  def change
    create_table :pool_epoches do |t|
      t.integer :blocks
      t.integer :total_stakes
      t.integer :size
      t.integer :pool_hash_id
      t.integer :pool_id

      t.timestamps
    end
  end
end
