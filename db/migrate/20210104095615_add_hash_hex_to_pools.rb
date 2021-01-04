class AddHashHexToPools < ActiveRecord::Migration[6.0]
  def change
    add_column :pools, :hash_hex, :string
  end
end
