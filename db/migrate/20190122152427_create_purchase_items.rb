class CreatePurchaseItems < ActiveRecord::Migration[5.2]
  def change
    create_table :purchase_items do |t|
      t.integer :purchase_id, null: false
      t.integer :product_id, null: false
      t.integer :quantity, null: false, :default => 1
      t.integer :price, null: false
      t.timestamps
    end
  end
end
