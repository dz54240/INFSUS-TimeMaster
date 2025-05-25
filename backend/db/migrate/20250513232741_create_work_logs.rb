# frozen_string_literal: true

class CreateWorkLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :work_logs do |t|
      t.timestamp :start_time, null: false
      t.timestamp :end_time, null: false
      t.string :activity_type, null: false
      t.text :description
      t.decimal :cost, precision: 10, scale: 2
      t.belongs_to :user, foreign_key: true, index: true, null: false
      t.belongs_to :project, foreign_key: true, index: true, null: false
      t.timestamps
    end
  end
end
