# frozen_string_literal: true

class CreateCharges < ActiveRecord::Migration[5.2]
  def change
    create_table :charges do |t|
      t.integer :payment_method_id, null: false
      t.integer :amount, null: false
      t.timestamps
    end
  end
end
