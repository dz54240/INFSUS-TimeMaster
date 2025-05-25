# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :description
      t.date :start_date
      t.date :end_date
      t.decimal :budget_amount, precision: 10, scale: 2
      t.belongs_to :organization, foreign_key: true, index: true, null: false
      t.timestamps
    end
  end
end
