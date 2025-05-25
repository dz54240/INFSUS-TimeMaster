# frozen_string_literal: true

# Include FactoryBot methods in Rails console
if defined?(Rails::Console)
  module FactoryBotConsole
    include FactoryBot::Syntax::Methods
  end
  FactoryBotConsole.include(FactoryBot::Syntax::Methods)
end
