class SpidrTest::ContextHandlers::Nil
  def self.handle?(context)
    context.nil?
  end

  def initialize(context)
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
