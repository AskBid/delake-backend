class AddDescriptionToPools < ActiveRecord::Migration[6.1]
  def change
    add_column :pools, :description, :string
  end
end
