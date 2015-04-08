# FIXME: make RSpec actually useful

if defined?(::RSpec::Core::ExampleGroup)
  require_relative 'base'

  module SpidrTest
    module Handlers
      class RSpec < Base
        def self.handle?(context)
          context.is_a?(::RSpec::Core::ExampleGroup)
        end
      end
    end
  end
end
