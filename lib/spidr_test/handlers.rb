module SpidrTest
  module Handlers
    def self.for(context)
      constants.each do |const_name|
        constant = const_get(const_name)
        if constant.respond_to?(:handle?) && constant.handle?(context)
          return constant.new(context)
        end
      end

      $stderr.puts "SpidrTest: context not understood. Using default handlers."
      Handlers::Default.new(nil)
    end
  end
end

require_relative 'handlers/default'
require_relative 'handlers/minitest'
require_relative 'handlers/rspec'
