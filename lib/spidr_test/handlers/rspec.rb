# FIXME: make RSpec actually useful (and not extend Nil handler)
require_relative 'nil'

if defined?(::RSpec::Core::ExampleGroup)
  class SpidrTest::Handlers::RSpec < SpidrTest::Handlers::Nil
    def self.handle?(context)
      context.is_a?(::RSpec::Core::ExampleGroup)
    end
  end
end
