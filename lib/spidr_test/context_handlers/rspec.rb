if defined?(::RSpec::Core::ExampleGroup)
  class SpidrTest::ContextHandlers::RSpec
    def self.handle?(context)
      context.is_a?(::RSpec::Core::ExampleGroup)
    end

    def initialize(context)
      @context = context
    end

    def success(url, page, msg)
    end

    def failure(url, page, msg)
      raise msg
    end

    def error(url, page, msg)
      raise msg
    end
  end
end
