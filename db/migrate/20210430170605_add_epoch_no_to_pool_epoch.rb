class AddEpochNoToPoolEpoch < ActiveRecord::Migration[6.1]
  def change
    add_column :pool_epoches, :epoch_no, :integer
  end
end
