# frozen_string_literal: true

class CreateBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :balances do |t|
      t.integer :amount, null: false
      t.integer :sales, null: false
      t.integer :card_added, null: false
      t.timestamps
    end
  end
end
