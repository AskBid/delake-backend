class CreateEpochDelegationsFlows < ActiveRecord::Migration[6.0]
  def change
    create_table :epoch_delegations_flows do |t|
      t.integer :epochno
      t.text :json

      t.timestamps
    end
  end
end
