# frozen_string_literal: true

class CreatePaymentMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_methods do |t|
      t.string :name, null: false
      t.string :addable, null: false, :default => 1
      t.string :uuid, null: false
      t.timestamps
    end
  end
end
