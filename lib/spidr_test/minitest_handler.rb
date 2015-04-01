class SpidrTest
  class MinitestHandler
    def self.===(context)
      defined?(Minitest) && context.is_a?(Minitest::Test)
    end

    def initialize(context)
      @context = context
    end

    def success(url, page)
      @context.pass url.path
    end

    def failure(url, page)
      begin
        raise Minitest::Assertion.new("Failure on #{url.path}: #{page.body}")
      rescue Minitest::Assertion => e
        @context.failures << e
      end
    end

    def error(url, page)
      begin
        raise Minitest::Assertion.new("Cannot connect to #{url.path}")
      rescue Minitest::Assertion => e
        self.failures << e
      end
    end
  end
end
