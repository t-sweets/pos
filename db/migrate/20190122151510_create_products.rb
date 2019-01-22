class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :price, null: false
      t.string :image_path, null: false
      t.integer :cost
      t.integer :stock
      t.boolean :display, null: false, :default => false
      t.timestamps
    end
  end
end
