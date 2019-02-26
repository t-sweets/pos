# frozen_string_literal: true

class CreateWithdraw < ActiveRecord::Migration[5.2]
  def change
    create_table :withdraws do |t|
      t.integer :amount, null: false
      t.timestamps
    end
  end
end
