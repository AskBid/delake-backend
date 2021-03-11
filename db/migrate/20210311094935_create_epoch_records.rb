class CreateEpochRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :epoch_records do |t|
      t.integer :epoch_no
      t.integer :supply

      t.timestamps
    end
  end
end
