class SpidrTest
  module ContextHandlers
    def self.for(context)
      constants.each do |const_name|
        constant = const_get(const_name)
        if constant.respond_to?(:handle?) && constant.handle?(context)
          return constant.new(context)
        end
      end
      nil
    end
  end
end

require_relative 'context_handlers/minitest'
require_relative 'context_handlers/rspec'