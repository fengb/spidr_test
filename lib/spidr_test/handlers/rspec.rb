# FIXME: make RSpec actually useful (and not extend Default handler)
require_relative 'default'

if defined?(::RSpec::Core::ExampleGroup)
  class SpidrTest::Handlers::RSpec < SpidrTest::Handlers::Default
    def self.handle?(context)
      context.is_a?(::RSpec::Core::ExampleGroup)
    end
  end
end
