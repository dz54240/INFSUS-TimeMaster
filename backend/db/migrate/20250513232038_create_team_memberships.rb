# frozen_string_literal: true

class CreateTeamMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :team_memberships do |t|
      t.belongs_to :team, foreign_key: true, index: true, null: false
      t.belongs_to :user, foreign_key: true, index: true, null: false
      t.timestamps
    end

    add_index :team_memberships, [:user_id, :team_id], unique: true
  end
end
