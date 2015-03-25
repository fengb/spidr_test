class SpidrTest
  autoload :Server, 'spidr_test/server'

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
    Server.run(app) do |server|
      `curl #{server.url}`
    end
  end
end
