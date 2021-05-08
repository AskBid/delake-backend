class AddPerformanceToPoolEpoches < ActiveRecord::Migration[6.1]
  def change
    add_column :pool_epoches, :performance, :integer
  end
end
