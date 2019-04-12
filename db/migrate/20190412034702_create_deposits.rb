# frozen_string_literal: true

class CreateDeposits < ActiveRecord::Migration[5.2]
  def change
    create_table :deposits do |t|
      t.integer :amount, null: false
      t.integer :register_id, null: false
    end
  end
end
