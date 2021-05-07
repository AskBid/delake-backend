class AddPerformanceToPools < ActiveRecord::Migration[6.1]
  def change
    add_column :pools, :performance, :integer
  end
end
