# frozen_string_literal: true

class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.string :token, index: { unique: true }
      t.belongs_to :user, foreign_key: true, null: false, index: false
      t.timestamp :expired_at
      t.timestamps
    end
  end
end
