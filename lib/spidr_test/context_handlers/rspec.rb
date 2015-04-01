if defined?(::RSpec::Core::ExampleGroup)
  class SpidrTest::ContextHandlers::RSpec
    def self.handle?(context)
      context.is_a?(::RSpec::Core::ExampleGroup)
    end

    def initialize(context)
      @context = context
    end

    def success(url, page)
    end

    def failure(url, page)
      raise "Failure on #{url}: #{page.body}"
    end

    def error(url, page)
      raise "Cannot connect to #{url}"
    end
  end
end
