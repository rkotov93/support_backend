class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.string :title
      t.text :description
      t.references :user, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
