# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, null: false, index: { unique: true }
      t.string :role, null: false
      t.text :password_digest
      t.date :birth_date
      t.decimal :hourly_rate, precision: 10, scale: 2
      t.timestamps
    end
  end
end
