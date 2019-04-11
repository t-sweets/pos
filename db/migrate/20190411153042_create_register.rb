# frozen_string_literal: true

class CreateRegister < ActiveRecord::Migration[5.2]
  def change
    create_table :registers do |t|
      t.string :name, null: false
      t.integer :initial_cash_amount, null: false
    end
  end
end
