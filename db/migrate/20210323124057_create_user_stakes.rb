class CreateUserStakes < ActiveRecord::Migration[6.0]
  def change
    create_table :user_stakes do |t|
      t.integer :user_id
      t.string :stake_address_id

      t.timestamps
    end
  end
end
