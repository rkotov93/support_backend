# frozen_string_literal: true
class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.integer :role, default: 0
      t.string :password_digest

      t.timestamps
    end
    add_index :users, :email
  end
end
