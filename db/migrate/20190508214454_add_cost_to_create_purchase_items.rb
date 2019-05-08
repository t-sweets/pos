class AddCostToCreatePurchaseItems < ActiveRecord::Migration[5.2]
  def change
    add_column :purchase_items, :cost, :integer, null: false, default: 0
  end
end
