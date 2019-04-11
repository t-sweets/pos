# frozen_string_literal: true

class CreateRegiChecks < ActiveRecord::Migration[5.2]
  def change
    create_table :regi_checks do |t|
      t.integer :user_id, null: false
      t.integer :register_id, null: false
      t.integer :register_cash_amount, null: false
      t.integer :pos_register_cash_amount, null: false
      t.timestamps
    end
  end
end
