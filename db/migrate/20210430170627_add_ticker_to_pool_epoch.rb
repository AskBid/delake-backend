class AddTickerToPoolEpoch < ActiveRecord::Migration[6.1]
  def change
    add_column :pool_epoches, :ticker, :string
  end
end
