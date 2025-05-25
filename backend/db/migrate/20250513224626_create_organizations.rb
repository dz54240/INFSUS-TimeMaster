# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[7.1]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.text :description
      t.date :established_at
      t.belongs_to :owner, foreign_key: { to_table: :users }, index: true, null: false
      t.timestamps
    end
  end
end
