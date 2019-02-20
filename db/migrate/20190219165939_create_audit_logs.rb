# frozen_string_literal: true

class CreateAuditLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :audit_logs do |t|
      t.string :model, null: false
      t.integer :model_id, null: false
      t.string :operation, null: false
      t.integer :operator
      t.string :detail, null: false
      t.timestamps
    end
  end
end
