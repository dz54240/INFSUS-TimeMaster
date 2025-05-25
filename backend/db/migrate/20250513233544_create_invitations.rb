# frozen_string_literal: true

class CreateInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :invitations do |t|
      t.string :token, index: { unique: true }
      t.boolean :token_used, null: false, default: false
      t.belongs_to :organization, foreign_key: true, index: true, null: false
      t.timestamps
    end
  end
end
