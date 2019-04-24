# frozen_string_literal: true

class CreateReturns < ActiveRecord::Migration[5.2]
  def change
    create_table :returns do |t|
      t.integer :purchase_id, null: false
      t.timestamps
    end
  end
end
