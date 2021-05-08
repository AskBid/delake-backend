class AddPerformanceToPoolEpochs < ActiveRecord::Migration[6.1]
  def change
    add_column :pool_epochs, :performance, :integer
  end
end
