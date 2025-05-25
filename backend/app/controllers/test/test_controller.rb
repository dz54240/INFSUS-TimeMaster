# frozen_string_literal: true

module Test
  class TestController < ApplicationController
    def reset
      ActiveRecord::Base.connection.disable_referential_integrity do
        ActiveRecord::Base.connection.tables.each do |table|
          next if table == 'schema_migrations'

          ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table} RESTART IDENTITY CASCADE")
        end
      end

      head :ok
    end
  end
end
