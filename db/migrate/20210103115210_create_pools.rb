class CreatePools < ActiveRecord::Migration[6.0]
  def change
    create_table :pools do |t|
      t.string :ticker
      t.string :url
      t.integer :pool_hash_id

      t.timestamps
    end
  end
end
