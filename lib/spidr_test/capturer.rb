module SpidrTest
  class Capturer < BasicObject
    def initialize
      @invocations = []
    end

    def method_missing(*args, &block)
      @invocations << args.push(block)
    end

    def _invoke(obj)
      @invocations.each do |args_block|
        *args, block = args_block
        obj.public_send(*args, &block)
      end
    end
  end
end
