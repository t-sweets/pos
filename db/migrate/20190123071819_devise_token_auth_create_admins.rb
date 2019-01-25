# frozen_string_literal: true

class DeviseTokenAuthCreateAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :admins do |t|

      ## Required
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""

      ## Database authenticatable
      t.string :encrypted_password, :null => false, :default => ""

      ## User Info
      t.string :name
      t.string :email

      ## Tokens
      t.text :tokens
      t.timestamps
    end
  end
end
