if defined?(::RSpec::Core::ExampleGroup)
  # FIXME: make RSpec actually useful (and not extend Nil handler)
  class SpidrTest::ContextHandlers::RSpec < SpidrTest::ContextHandlers::Nil
    def self.handle?(context)
      context.is_a?(::RSpec::Core::ExampleGroup)
    end
  end
end
