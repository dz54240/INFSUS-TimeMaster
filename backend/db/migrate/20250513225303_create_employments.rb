# frozen_string_literal: true

class CreateEmployments < ActiveRecord::Migration[7.1]
  def change
    create_table :employments do |t|
      t.belongs_to :user, foreign_key: true, null: false, index: false
      t.belongs_to :organization, foreign_key: true, null: false, index: true
      t.timestamps
    end

    add_index :employments, [:user_id, :organization_id], unique: true
  end
end
