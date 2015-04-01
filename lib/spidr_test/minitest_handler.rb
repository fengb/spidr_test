class SpidrTest
  class MinitestHandler
    def self.===(context)
      defined?(Minitest) && context.is_a?(Minitest::Test)
    end

    def initialize(context)
      @context = context
    end

    def success(url, page)
      @context.pass url
    end

    def failure(url, page)
      @context.failures << assertion("Failure on #{url}: #{page.body}")
    end

    def error(url, page)
      @context.failures << assertion("Cannot connect to #{url}")
    end

    def assertion(msg)
      raise MiniTest::Assertion.new(msg)
    rescue Minitest::Assertion => e
      return e
    end
  end
end
