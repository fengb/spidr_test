class SpidrTest::ContextHandlers::Nil
  def self.handle?(context)
    context.nil?
  end

  def initialize(context)
  end

  def success(url, page, msg)
  end

  def failure(url, page, msg)
    raise msg
  end

  def error(url, page, msg)
    raise msg
  end
end
