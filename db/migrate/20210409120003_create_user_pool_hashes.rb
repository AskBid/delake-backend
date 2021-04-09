class CreateUserPoolHashes < ActiveRecord::Migration[6.1]
  def change
    create_table :user_pool_hashes do |t|
      t.integer :pool_hash_id
      t.integer :user_id

      t.timestamps
    end
  end
end
