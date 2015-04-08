# FIXME: actually report Cucumber style
#
if defined?(::Cucumber::RbSupport::RbWorld)
  require_relative 'base'

  module SpidrTest
    module Handlers
      class Cucumber < Base
        def self.handle?(context)
          context.is_a?(::Cucumber::RbSupport::RbWorld)
        end
      end
    end
  end
end
