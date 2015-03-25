class SpidrTest
  def self.crawl(context, &block)
    spidr_test = SpidrTest.new(context)
    spidr_test.config(&block)
    spidr_test.run!
  end

  attr_accessor :app

  def initialize(context)
    @context = context
  end

  def config
    yield self
  end

  def run!
    app.call({})
  end
end
