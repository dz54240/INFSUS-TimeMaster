# frozen_string_literal: true

class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.text :description
      t.belongs_to :organization, foreign_key: true, index: true, null: false
      t.timestamps
    end
  end
end
