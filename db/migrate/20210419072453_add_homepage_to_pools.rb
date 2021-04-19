class AddHomepageToPools < ActiveRecord::Migration[6.1]
  def change
    add_column :pools, :homepage, :string
  end
end
