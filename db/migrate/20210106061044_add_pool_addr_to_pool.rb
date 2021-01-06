class AddPoolAddrToPool < ActiveRecord::Migration[6.0]
  def change
    add_column :pools, :pool_addr, :string
  end
end
