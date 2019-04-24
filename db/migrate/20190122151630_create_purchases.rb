# frozen_string_literal: true

class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.integer :payment_method_id, null: false
      t.string :payment_uuid, null: false
      t.boolean :deleted, null: false, default: false
      t.timestamps
    end
  end
end
