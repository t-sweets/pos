class CreateRegiChecks < ActiveRecord::Migration[5.2]
  def change
    create_table :regi_checks do |t|
      t.integer :user_id, null: false
      t.integer :regi_amount, null: false
      t.integer :pos_regi_amount, null: false
      t.timestamps
    end
  end
end
