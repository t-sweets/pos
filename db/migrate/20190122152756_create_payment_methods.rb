# frozen_string_literal: true

class CreatePaymentMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_methods do |t|
      t.string :name, null: false
      t.boolean :addable, null: false, default: true
      t.string :uuid, null: false
      t.timestamps
    end
  end
end
