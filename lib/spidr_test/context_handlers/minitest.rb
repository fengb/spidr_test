if defined?(::Minitest::Test)
  class SpidrTest::ContextHandlers::Minitest
    def self.handle?(context)
      context.is_a?(::Minitest::Test)
    end

    def initialize(context)
      @context = context
    end

    def success(url, page, msg)
      @context.pass url
    end

    def failure(url, page, msg)
      @context.failures << assertion(msg)
    end

    def error(url, page, msg)
      @context.failures << assertion(msg)
    end

    def assertion(msg)
      raise ::MiniTest::Assertion.new(msg)
    rescue ::Minitest::Assertion => e
      return e
    end
  end
end
