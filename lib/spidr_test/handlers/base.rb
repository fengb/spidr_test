module SpidrTest
  module Handlers
    class Base
      def self.handle?(context)
        context.nil?
      end

      def initialize(context)
        @context = context
      end

      def success(options)
      end

      def failure(options)
        raise options[:message]
      end

      def error(options)
        raise options[:message]
      end
    end
  end
end
