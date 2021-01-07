class AddTickerToEpochPoolSize < ActiveRecord::Migration[6.0]
  def change
    add_column :epoch_pool_sizes, :ticker, :string
  end
end
