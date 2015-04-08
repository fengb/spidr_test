if defined?(::Minitest::Test)
  require_relative 'base'

  module SpidrTest
    module Handlers
      class Minitest < Base
        def self.handle?(context)
          context.is_a?(::Minitest::Test)
        end

        def success(options)
          @context.pass options[:message]
        end

        def failure(options)
          @context.failures << create_assertion(options[:message])
        end

        def error(options)
          @context.failures << create_assertion(options[:message])
        end

        def create_assertion(msg)
          raise ::MiniTest::Assertion.new(msg)
        rescue ::Minitest::Assertion => e
          return e
        end
      end
    end
  end
end
